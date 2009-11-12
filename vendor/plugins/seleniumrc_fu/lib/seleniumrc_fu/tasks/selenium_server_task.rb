module SeleniumrcFu
  module Tasks
    class SeleniumServerTask
      def initialize(jarfile, interactive = true)
        @jarfile = jarfile
        if @jarfile.nil?
          dir = File.dirname(__FILE__)
          selenium_dir = File.expand_path("#{dir}/../../../bin")
          @jarfile = "#{selenium_dir}/selenium-server-0-8-1.jar"
        end
        @interactive = interactive
      end

      def invoke
        cmd = "java -jar #{@jarfile}"
        cmd << " -interactive" if @interactive
        cmd.gsub! File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR
        puts cmd
        system cmd
      end
    end
  end
end