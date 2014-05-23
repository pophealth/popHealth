require 'sshkit/dsl'
namespace :sharding do
SSHKit.config.backend.config.pty=true
  @@templates = {}
  def rc()
    unless @rendering_context 
      template_helper = HealthDataStandards::Export::TemplateHelper.new("conf", nil, "./script/sharding/templates")
      @rendering_context = HealthDataStandards::Export::RenderingContext.new
      @rendering_context.template_helper = template_helper
    end
    @rendering_context
  end

  def wait_for_start(host,port,tries=5)
    session = Moped::Session.new(["#{host}:#{port}"])
    session.use :config
    connected = false
    while tries > 0 && !connected do
      begin
        session.collections
        connected = true
        break
      rescue
        puts "#{host}:#{port} not connected"
        tries = tries - 1
      end
    end
    connected
  end

  def already_sharded(host,port,mongos_server)
    session = Moped::Session.new([mongos_server])
    session.use :config
    session["shards"].find({host: "#{host}:#{port}"}).count > 0
  end
  
  def add_shard_to_config(host,port,mongos_server)
    session = Moped::Session.new([mongos_server])
    session.use :admin
    session.command({addshard: "#{host}:#{port}"})
  end

  def shard_config_server(host,port,ph_db_name)
    session = Moped::Session.new(["#{host}:#{port}"])
    session.use ph_db_name
    session['records'].indexes.create({medical_record_number:1})
    session['patient_cache'].indexes.create({_id:1})
    session.use :admin
    session.command( {enablesharding: ph_db_name } )
    session.command({shardcollection: "#{ph_db_name}.records", key: {medical_record_number: 1}})
    session.command({shardcollection: "#{ph_db_name}.patient_cache", key: {_id: 1}})
  end

  def parse_js_file(bundle_path)
   js_files = []
    Zip::ZipFile.open(bundle_path) do |zip_file|
      zip_file.glob(File.join('library_functions','*.js')).each do |entry|
        name = Pathname.new(entry.name).basename('.js').to_s
        contents = entry.get_input_stream.read
        fn = "function () {\n #{contents} \n }"
        js_files << {_id: name, value: Moped::BSON::Code.new(fn)}
      end
    end
    js_files
  end

  def upload_and_move_file(file_or_io,to_file,move_file,permissions ="644",owner="root:root")
    execute :mkdir, "-p etc/init"
    upload! file_or_io, to_file
    execute "sudo mv #{to_file} #{move_file}"
    execute "sudo chmod #{permissions} #{move_file}" if permissions
    execute "sudo chown #{owner} #{move_file}"  if owner
  end



  desc "Add a single shard to a machine" 
  task :add_shard, [:host,:mongos_server] => :environment do |t,args|
    on args.host do |host|
      i = 0
      port = 27020
      begin
        #assume standards mongodb#{n} naming convention on host server 
        #look for already installed instances
        while true
          i += 1
          port += 1
          execute :ls, "/etc/mongodb#{i}.conf"
        end
      rescue
        puts "Assuming instance #{i} on host machine"
      end
      name = "mongodb#{i}"
      config = StringIO.new(rc.render({template:"mongodb",locals: {name: name,shardsvr: true, host:host, port: port}}) )
      upstart = StringIO.new(rc.render({template:"upstart", locals:{name: name}}))
      upload! config ,   "/etc/#{name}.conf"
      upload! upstart ,   "/etc/init/#{name}.conf"
      execute "sudo service #{name} start"
      sleep 3
      add_shard_to_config(host,port,args.mongos_server)
    end
  end

  desc "Add the javascript files to a single host"
  task :add_js_to_host, [:host,:port,:ph_db_name,:bundle_path] => :environment do |t,args|
    js_files = parse_js_file(args.bundle_path)
    session = Moped::Session.new("#{host}:#{port}")
    session.use args.ph_db_name
    js_files.each do |js|
        host_session["system.js"].insert(js)
    end
  end
  

  desc "Shard a machine " 
  task :shard_machine, [:host,:shard_count,:mongos_server,:ph_db_name] => :environment do |t,args|
    #make sure we can contact the config server
    on args.host do |host|
      port = 27020
      count = args.shard_count.to_i
      count.times do |i|
        port += 1
        name = "mongodb#{i}"
        if already_sharded(host,port,args.mongos_server)
          puts "#{host}:#{port} already sharded"
          next
        end
        config = StringIO.new(rc.render({template:"mongodb",locals: {name: name,shardsvr: true, host:host, port: port}})) 
        upstart = StringIO.new(rc.render({template:"upstart", locals:{name: name}}))
        upload_and_move_file config ,"etc/#{name}.conf","/etc/#{name}.conf"
        upload_and_move_file upstart ,   "etc/init/#{name}.conf", "/etc/init/#{name}.conf"
        begin
          execute "sudo stop #{name} "
        rescue
        end
        execute "sudo start #{name} "
        connected = wait_for_start(host,port,5)
        if connected
          add_shard_to_config(host,port,args.mongos_server) 
        else
          puts "shard not started not adding to cluster"
        end
      end
    end
  end

  desc "Setup each shard in the cluster with the system js files needed to calculate the measures" 
  task :setup_js, [:mongos_server,:ph_db_name,:bundle_path] => :environment do |t,args|
    #open zip and read js files
    js_files = parse_js_file(args.bundle_path)
    session = Moped::Session.new(args.mongos_server)
    session.use :admin

    session["shards"].find({}).each do |shard|
      host_session = Moped::Session.new(shard["host"])
      host_session.use args.ph_db_name
      # insert the js files into the system js collection on the shards
      js_files.each do |js|
        host_session["system.js"].insert(js)
      end
    end
  end



  desc "Set up mongos and mongoconfig on a server" 
  task :setup_config, [:host,:ph_db_name] => :environment do |t,args|
    on args.host do |host|
     # does the mongoconfig server conf already exist? 
     begin
       execute :ls, '-l /etc/mongoconfig.conf' 
       execute :ls, '-l /etc/init/mongoconfig.conf'
       execute :ls, '-l /etc/init/mongos.conf'
     rescue
      puts "mongo configserver or mongos files already exist on target host"
     end


     upload_and_move_file StringIO.new(rc.render({template: "mongodb",locals: {name: "mongoconfig",config_server: true,host: host,port: 27019}}) ), 'etc/mongoconfig.conf','/etc/mongoconfig.conf'
     upload_and_move_file StringIO.new(rc.render({template:"upstart",locals: {name: "mongoconfig"}}) ),'etc/init/mongoconfig.conf','/etc/init/mongoconfig.conf'
     upload_and_move_file StringIO.new(rc.render({template:"mongos",locals: {config_server: "#{host}:27019"}})) ,'etc/init/mongos.conf','/etc/init/mongos.conf'
     begin 
       execute "sudo stop mongoconfig "
       execute "sudo stop mongos "
     rescue
     end
     execute "sudo start mongoconfig "
     sleep 3
     execute "sudo start mongos "
     parts = args.host.split("@")
     _host = parts.length ==0 ? parts[0] : parts[1]
     shard_config_server(_host,27017,args.ph_db_name)
    end
  end

  task :test,[:host] => :environment do |t,args|
    on args.host do |host|
      as :root do 
        puts host
       puts capture(  :tail, "/etc/sudoers" )
     end
    end
  end
end
