require 'fileutils'

namespace :ccr do
  dest_dir = File.join(Rails.root, 'resources', 'ccr', 'jars')

  desc 'Install the CCR importer module (to resources/ccr/jars)'
  task :install => :environment do
    src_dir = ENV['CCR_INSTALLER'] || File.expand_path('../ccr-importer', Rails.root)
    install_jars(src_dir, dest_dir)
  end

  desc 'Uninstall the CCR importer module (from resources/ccr/jars)'
  task :uninstall => :environment do
    Dir.glob(File.join(dest_dir, '*.jar')).each do |jar_file|
      File.delete(jar_file)
    end
    Dir.delete(dest_dir)
  end
  
  def install_jars(src_dir, dest_dir)
    if !File.directory?(src_dir)
      puts "CCR Importer Source Directory (#{src_dir}) not found, set $CCR_INSTALLER to the correct path"
      return
    end
    if !File.directory?(dest_dir)
      Dir.mkdir(dest_dir)
    end
    FileUtils.cp(File.join(src_dir, 'dist', 'ccr-importer.jar'), dest_dir)
    Dir.glob(File.join(src_dir, 'lib', '*.jar')).each do |jar_file|
      FileUtils.cp(jar_file, dest_dir)
    end
  end
  
end