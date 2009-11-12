require File.dirname(__FILE__) + "/selenium_helper"  

module Laika::DashboardTest

  class JustLoggedIn < Laika::SeleniumTestCase
    fixtures :users, :patients, :user_roles, :roles, :vendors

    def test_reservation_party_meal_info_flow
      login users(:alex_kroman)
      assert_title 'Laika Test Library'
    end
  end

end
