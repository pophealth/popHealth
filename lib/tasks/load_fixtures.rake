namespace :db do
	namespace :fixtures do
	    desc "Load fixtures into the current environment's database.  Load specific fixtures using FIXTURES=x,y"
	    task :load_from_dir => :environment do
	       require 'active_record/fixtures'
	       fixture_dir = ENV['FIXTURE_DIR'] ? ENV['FIXTURE_DIR'] : 'test/fixtures'
	       ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
	      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, fixture_dir, '*.{yml,csv}'))).each do |fixture_file|
	          Fixtures.create_fixtures(fixture_dir , File.basename(fixture_file, '.*'))
	       end
	    end
	end
end
     