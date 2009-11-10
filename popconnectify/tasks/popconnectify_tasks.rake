namespace :popconnectify do
  desc "Synchronizes extra files from popconnectify plugin"
  task :sync do
    system "rsync -ruv vendor/plugins/popconnectify/db/migrate db"
    system "rsync -ruv vendor/plugins/popconnectify/public ."
  end
end