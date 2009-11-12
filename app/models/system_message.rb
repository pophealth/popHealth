class SystemMessage < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  attr_readonly :author

  belongs_to :updater, :class_name => 'User'
  attr_protected :updater

  validates_presence_of :author_id, :body

  def validate
    errors.add('author', 'must be an administrator') unless author.administrator?
    errors.add('updater', 'must be an administrator') if updater and not updater.administrator?
  end

  # Has the message has been updated by someone other than the original author?
  def updated?
    updater && author != updater
  end

end
