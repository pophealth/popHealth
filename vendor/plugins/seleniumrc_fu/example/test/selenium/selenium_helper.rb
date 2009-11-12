dir = File.dirname(__FILE__)
require dir + "/../test_helper"
require "seleniumrc_fu/selenium_helper"

module Example
  class SeleniumTestCase < SeleniumrcFu::SeleniumTestCase
    def silly_helper
      click_and_wait("link=About your application’s environment")
    end
  end

  class SeleniumCharacterization < Example::SeleniumTestCase
    include SeleniumrcFu::SeleniumCharacterization
  end
end
