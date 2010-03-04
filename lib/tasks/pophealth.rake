
def find_user(env)
  case
    when env.key?('USER_ID'):
      User.find env['USER_ID']
    when env.key?('EMAIL'):
      User.find_by_email env['EMAIL']
  end
end


namespace :db do
  namespace :fixtures do
    #rake db:fixtures:single fixture=questions
    desc "Loads a single fixture by setting fixture=name of fixture you wish to laod."
    task :single => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
      Fixtures.create_fixtures("spec/fixtures", [ENV['fixture']])
      puts "Fixture (#{ENV['fixture']}) loaded into #{RAILS_ENV}."
    end
  end
end


namespace :ph do
  
  desc "Run blueprint compress"
  task :blueprint do
    fhi = IO.popen("jruby public/stylesheets/lib/compress.rb -p pophealth -o public/stylesheets/app ")
    while (line = fhi.gets)
          print line
            print "and"
    end
    
    fhi = IO.popen("jruby public/stylesheets/lib/compress.rb -p account -o public/stylesheets/account ")
    while (line = fhi.gets)
          print line
            print "and"
    end
  end

  desc "Load random data into the current environment's database."
  task :randomize => :environment do
    print "How many patient records do you want to create ? "

    count = $stdin.gets.to_i

    puts "you have decided to create #{count} random patient records."
    puts "hit ctrl + c to stop script at anytime."
    puts "starting..."

    if count > 1000
      modulus = 100
    else
      modulus = 10
    end

    i=0
    while i<= count
      begin
        patient = Patient.new
        patient.randomize()
        patient.save!
        i += 1
        if i % modulus == 0
          puts i.to_s + " patient records done ..." 
        end
      rescue
        puts "ERROR creating patient " + i.to_s + ": "+ $!
      end
    end
  end
  
  
  desc "Import patient records from C32 files in specified directory into database."
  task :import => :environment do
    print "Please specify the full path for the directory of C32 files: "

    begin 
      dir = Dir.new($stdin.gets.strip!)
      count = 0
      puts "Beginning import ... hit ctrl + c to stop script at any time."
      dir.each { |file_name|
        if File.extname(file_name) == ".xml"
          File.open(dir.path + file_name) do |file|
            begin 
              PatientC32Importer.import_c32(REXML::Document.new(file))
              count += 1
            rescue
              puts "Error importing patient: "+ $!
            end
          end
        end
      }
      puts "Imported #{count} C32 patient record(s) into the popHealth database"
    rescue SystemCallError
      puts "Invalid directory name: "+ $!
    end
  end
  
  
  
  namespace :admin do

    desc %{Make an existing Laika user an administrator.

    You must identify the user by USER_ID or EMAIL:

    $ rake laika:make_admin USER_ID=###
    or
    $ rake laika:make_admin EMAIL=xxx}
    task :make => :environment do
      raise 'must pass USER_ID or EMAIL' unless ENV['USER_ID'] || ENV['EMAIL']
      user = find_user ENV
      raise 'There is no such user.' unless user
      raise "#{user.display_name} is already an administrator." if user.administrator?
      user.grant_admin
      puts "#{user.display_name} is now an administrator"
    end

    desc %{Remove the administrator role from a Laika user.

    You must identify the user by USER_ID or EMAIL:

    $ rake laika:unmake_admin USER_ID=###
    or
    $ rake laika:unmake_admin EMAIL=xxx}
    task :unmake => :environment do
      raise 'must pass USER_ID or EMAIL' unless ENV['USER_ID'] || ENV['EMAIL']
      user = find_user ENV
      raise 'There is no such user.' unless user
      raise "#{user.display_name} is not an administrator." if not user.administrator?
      user.revoke_admin
      puts "#{user.display_name} is no longer an administrator"
    end
  end
end