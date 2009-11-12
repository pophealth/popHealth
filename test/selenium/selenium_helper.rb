ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
require 'test_help'
require "seleniumrc_fu/selenium_helper"


module Laika
  class SeleniumTestCase < SeleniumrcFu::SeleniumTestCase
    def login(user, opts = {})
      open_and_wait "/account/login"
      assert_title 'Welcome to Laika'
      type 'email', user.email
      type 'password', opts[:password] || 'laika'
      click_and_wait_for_page_to_load 'link=Login'
    end
  end

  class SeleniumCharacterization < Laika::SeleniumTestCase
    include SeleniumrcFu::SeleniumCharacterization
  end
end
