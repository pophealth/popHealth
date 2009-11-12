require File.dirname(__FILE__) + '/../spec_helper'
require 'sort_order'

class SortOrderTestController < ActionController::Base
  def rescue_action(e) raise e end

  include SortOrder
  def foo
    render :text => 'hi foo'
  end
  def bar
    render :text => 'hi bar'
  end
end

module SortOrderTestHelper
  def test_sort_routes
    with_routing do |map|
      map.draw {|test| test.connect "/sort_order/:action", :controller => 'sort_order_test' }
      yield
    end
  end
end

describe SortOrderTestController do
  include SortOrderTestHelper

  it "should not respond to sort_order as an action" do
    pending "not working in JRuby 1.3.1"
    test_sort_routes do
      lambda { get :sort_order }.should raise_error(ActionController::UnknownAction)
    end
  end

  it "should not respond to sort_spec as an action" do
    pending "not working in JRuby 1.3.1"
    test_sort_routes do
      lambda { get :sort_spec }.should raise_error(ActionController::UnknownAction)
    end
  end

  it "should have nil sort order if no sort is given" do
    test_sort_routes do
      get :foo
      @controller.sort_order.should be_nil
    end
  end

  it "should have nil sort order if a malformed sort is given" do
    test_sort_routes do
      get :foo, :sort => ';delete from important_table'
      @controller.sort_order.should be_nil

      get :foo, :sort => '--comment'
      @controller.sort_order.should be_nil

      get :foo, :sort => '/*comment*/'
      @controller.sort_order.should be_nil
    end
  end

  it "should correctly set the sort order given a sort key" do
    test_sort_routes do
      get :foo, :sort => 'updated_at'
      @controller.sort_order.should == 'updated_at ASC'

      get :foo, :sort => '-updated_at'
      @controller.sort_order.should == 'updated_at DESC'
    end
  end

  it "should reuse the sort order in subsequent calls to the same action" do
    test_sort_routes do
      get :foo
      @controller.sort_order.should be_nil

      get :foo, :sort => '-updated_at'
      @controller.sort_order.should == 'updated_at DESC'

      get :foo
      @controller.sort_order.should == 'updated_at DESC'
    end
  end

  it "should not reuse the sort order in subsequent calls to different actions" do
    test_sort_routes do
      get :foo, :sort => 'updated_at'
      @controller.sort_order.should == 'updated_at ASC'

      get :bar
      @controller.sort_order.should be_nil
    end
  end

  describe "with valid_sort_fields specified" do

    before(:all) { SortOrderTestController.valid_sort_fields = %w[updated_at] }
    after(:all)  { SortOrderTestController.valid_sort_fields = nil }

    it "should respect valid sort specs" do
      test_sort_routes do
        get :foo, :sort => 'updated_at'
        @controller.sort_order.should == 'updated_at ASC'
      end
    end

    it "should not respect invalid sort specs" do
      test_sort_routes do
        get :foo, :sort => 'created_at'
        @controller.sort_order.should be_nil
      end
    end
  end
end
