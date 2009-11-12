require 'seleniumrc_fu/selenium_characterization/css_characterizer'

module SeleniumrcFu
  
  # Include this module in your SeleniumTestCase to enable characterization tests.
  # http://en.wikipedia.org/wiki/Characterization_Test
  module SeleniumCharacterization
    def characterization_enabled?
      true
    end

    class Dispatcher
      @@characterizers = []
      @@mode = ENV['characterization_mode']
      
      def self.register(characterizer_class)
        @@characterizers << characterizer_class
      end
      
      def self.dispatch(context, selenium, test_class)
        if @@mode
          storage_path = File.join(context.rails_root, 'test', 'selenium', test_class.class.name.underscore)
          @@characterizers.map { |c| c.new(test_class, storage_path).send(@@mode, selenium) }
        end
      end
    end
  end
  
end

