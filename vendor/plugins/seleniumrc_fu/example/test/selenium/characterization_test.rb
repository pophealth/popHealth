require File.dirname(__FILE__) + "/selenium_helper"  

module CharacterizationTest
  class ElementsTest < Example::SeleniumCharacterization
    def test_index
      open_and_wait('/')
      assert_text_present('Listing elements')
    end
  end
end
