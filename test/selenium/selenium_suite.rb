require File.dirname(__FILE__) + "/selenium_helper"

class SeleniumSuite
  def run
    test_files = Dir.glob("#{File.dirname(__FILE__)}/*_test.rb")
    test_files.each do |x|
      require File.expand_path(x)
    end
    
    browsers = SeleniumrcFu::SeleniumConfiguration.instance.browsers
    if browsers.to_s.empty?
      SeleniumrcFu::SeleniumConfiguration.instance.browsers = ["firefox"]
    end
  end
end

SeleniumSuite.new.run
