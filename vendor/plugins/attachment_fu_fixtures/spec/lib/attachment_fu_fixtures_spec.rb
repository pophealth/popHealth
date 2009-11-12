RAILS_GEM_VERSION = ENV['RAILS_GEM_VERSION'] unless ENV['RAILS_GEM_VERSION'].nil?

begin
  require 'rubygems'
  require 'ruby-debug'
rescue LoadError
  # pass
end

require 'fileutils'
require File.dirname(__FILE__) + '/../../../../../spec/spec_helper'

Spec::Runner.configure do |config|
  # we're testing fixture loading, which itself uses transactions, so
  # transactional fixtures must be turned off to recreate true behaviour;
  # creating the first fixture causes a begin_db_transaction request which
  # seems to be the root of the ugly "SQL login error or missing database"
  # problem.
  config.use_transactional_fixtures = false
end

# --------------------------------------------------
# SCHEMA
# --------------------------------------------------
# (thanks to rsl for inline schema definition
#  http://github.com/rsl/stringex/tree/5aa45b8aeec2c0dd7d8f28af879d12e0b54b1bfe/test/acts_as_url_test.rb)
ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :dbfile   => File.join(File.dirname(__FILE__), '../../db', 'test.sqlite3')
)
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :images, :force => true do |t|
    t.integer :size
    t.integer :height
    t.integer :width
    t.string  :content_type
    t.string  :filename
    t.string  :thumbnail
    t.integer :parent_id
    t.integer :product_id
    t.timestamps
  end
  create_table :products, :force => true do |t|
    t.string  :brand
    t.string  :name
    t.integer :qty
    t.text    :description
    t.timestamps
  end
  create_table :gizmos, :force => true do |t|
    t.string  :name
    t.timestamps
  end

  # gizmos <=> images join table
  create_table :gizmos_images, :force => true do |t|
    t.integer :gizmo_id, :image_id
  end

  # STI
  create_table :posts, :force => true do |t|
    t.string :title
  #sti attr
    t.string :type
    t.string :kind #alternative inheritance_column
  #attachment_fu attrs
    t.integer :size
    t.string  :content_type
    t.string  :filename
  end
end
ActiveRecord::Migration.verbose = true

# --------------------------------------------------
# FIXTURES
# --------------------------------------------------
module Neverland #namespace

  # directory containing test attachment files
  ATTACHMENT_DIR = File.join(File.dirname(__FILE__), '../assets/')

  # full attachment file paths
  # (manually declared in order to avoid susprises in specs)
  # note: make sure files appear in attachment dir!
  mattr_reader :attachments
  @@attachments = %w[ rails.png railz.png ].map {|name| File.join(ATTACHMENT_DIR, name) }

  mattr_accessor :fixture_files
  @@fixture_files = {}

  @@fixture_files['images'] = %|
  peter:
    attachment_file: #{self.attachments[0]}
    product: clock
  tinkerbell:
    attachment_file: #{self.attachments[1]}
    product: timer
  |
  @@fixture_files['products'] = %|
  clock:
    brand: crocodile
    name: $LABEL
    qty: 100
    description: tick, tack
  timer:
    brand: asdf
    name: $LABEL
    qty: 2
    description: tiny
  |
  @@fixture_files['gizmos'] = %|
  foo:
    name: $LABEL
    images: peter, tinkerbell
  bar:
    name: $LABEL
    images: peter
  |

  #STI fixtures
  @@fixture_files['posts'] = %|
  # posts:
  first_post:
    title: $LABEL
    type: Post
  other_post:
    title: $LABEL
    type: Post

  # articles:
  pirates:
    type: Article
  fairies:
    type: Article

  # documents:
  treasure_map.odt:
    type: Document
    attachment_file: #{self.attachments[0]}
  treasure_map.pdf:
    type: Document
    attachment_file: #{self.attachments[1]}
  |
end

class String
  def to_fixtures
    YAML.load(ERB.new(self).result).to_hash
  end
end

Fixtures.class_eval do
  def read_fixture_files
    Neverland.fixture_files[@table_name].to_fixtures.each do |label, data|
      self[label] = Fixture.new(data, model_class)
    end
  end
end

# --------------------------------------------------
# MODELS
# --------------------------------------------------
class Image < ActiveRecord::Base
  belongs_to :product
  has_and_belongs_to_many :gizmos
  has_attachment :path_prefix   => File.join(File.dirname(__FILE__), '../tmp'),
                 :thumbnails    => {:sample => '100x100>'},
                 :storage       => :file_system
  validates_as_attachment
end

class Product < ActiveRecord::Base
  has_one :image
end

class Gizmo < ActiveRecord::Base
  has_and_belongs_to_many :images
end

# STI
class Post < ActiveRecord::Base; end
class Article < Post; end
class Document < Post
  has_attachment :path_prefix   => File.join(File.dirname(__FILE__), '../tmp'),
                 :thumbnails    => {:sample => '100x100>'},
                 :storage       => :file_system
  validates_as_attachment
end

# --------------------------------------------------
# SPECS
# --------------------------------------------------
# todo: test with other dbs

describe "rake [spec:]db:fixtures:load handling attachment fixtures" do
  TEMP_DIR = File.join(File.dirname(__FILE__), '../tmp/')

  before(:each) do
    Fixtures.reset_cache
  end

  after(:each) do
    begin
      Image.destroy_all
    rescue
      Image.delete_all
    end
  end

  after(:all) do
    FileUtils.rm_rf(Dir[File.join(TEMP_DIR, '**/*')])
  end

  it "should add the attachments and their thumbnails to the database" do
    lambda { insert_data }.should change(Image, :count).by(4)
    Image.find(:all).select(&:parent_id).should have(2).happythoughts
    Image.find(:all).reject(&:parent_id).should have(2).happythoughts_too
  end

  it "should assign the right id to the record" do
    insert_data
    Image.find_by_filename('rails.png').id.should == data['images']['peter']['id']
    Image.find_by_filename('railz.png').id.should == data['images']['tinkerbell']['id']
  end

  it "should properly build associations that include attachments" do
    insert_data
    Product.find_by_name('clock').image.id.should == data['images']['peter']['id']
    Product.find_by_name('timer').image.id.should == data['images']['tinkerbell']['id']
  end

  it "should link attachment models to valid attachment files" do
    insert_data
    Product.find(:all).each do |product|
      File.exist?(product.image.public_filename).should be_true
      File.exist?(product.image.public_filename(:sample)).should be_true
      File.exist?(product.image.public_filename(:hook)).should_not be_true
    end
  end

  it "should raise an exception if fixture file doesn't exist" do
    with_bad_image_path do
      lambda {
        insert_data
      }.should raise_error(Mynyml::AttachmentFuFixtures::AttachmentFileNotFound)
    end
  end

  it "should not raise an error when attachment_file is not specified" do
    without_defined_attachment_files do
      lambda {
        insert_data
      }.should_not raise_error(Mynyml::AttachmentFuFixtures::AttachmentFileNotFound)
    end
  end

  it "should process models as normal fixtures when attachment_file if not specified" do
    without_defined_attachment_files do
      lambda { insert_data }.should change(Image, :count).by(2)
    end
    Image.find_by_filename('rails.png').should be_nil
    Image.find_by_filename('railz.png').should be_nil
  end

  it "should handle HABTM relationships" do
    insert_data
    Gizmo.find_by_name('foo').images.map(&:filename).should include('rails.png','railz.png')
    Gizmo.find_by_name('bar').images.map(&:filename).should include('rails.png')
  end

  it "should handle STI" do
    insert_data
    Document.find(:all).map(&:filename).should include('rails.png','railz.png')
  end

  it "should respect STI inheritance column" do
    Neverland.fixture_files['posts'].gsub!(/type/,'kind')
    #-----
    lambda {
      insert_data
    }.should raise_error
    #-----
    Post.inheritance_column = 'kind'
    lambda {
      insert_data
    }.should_not raise_error
  end

  # --------------------------------------------------
  # Helper Methods
  # --------------------------------------------------
  def insert_data(fixtures=[])
    fixtures_files = fixture_file_names if fixtures.empty?
    fixtures_files.each do |fixture_file|
      Fixtures.create_fixtures('path/to/neverland', fixture_file)
    end
  end

  def data
    @data ||= begin
      data = Neverland.fixture_files.dup
      data.each do |name, yaml|
        fixtures = yaml.to_fixtures
        fixtures.each do |label, row|
          row['id'] = Fixtures.identify(label) if row['id'].nil?
        end
        data[name] = fixtures
      end
      data
    end
  end

  def fixture_file_names
    Neverland.fixture_files.keys
  end

  def with_bad_image_path
    orig = Neverland.attachments.first
    temp = File.join(TEMP_DIR, File.basename(orig))
    FileUtils.mv(orig, temp)
    yield
  ensure
    FileUtils.mv(temp, orig)
  end

  def without_defined_attachment_files
    orig_fxs = Neverland.fixture_files['images'].dup
    Neverland.fixture_files['images'].gsub!(/\n\s*attachment_file:.*$/, '')
    yield
    Neverland.fixture_files['images'] = orig_fxs
  end
end
