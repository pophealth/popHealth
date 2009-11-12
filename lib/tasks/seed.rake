namespace :db do
  desc "Load seed data into the current environment's database."
  task :seed => :environment do
    require 'active_record/fixtures'
    fixture_dir = 'spec/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    Dir.glob(File.join(RAILS_ROOT, fixture_dir, '*.yml')).each do |f|
      Fixtures.create_fixtures(fixture_dir , File.basename(f, '.yml'))
    end
  end
end

