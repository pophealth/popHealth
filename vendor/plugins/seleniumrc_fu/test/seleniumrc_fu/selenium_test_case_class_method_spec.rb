require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module SeleniumrcFu
describe SeleniumTestCase, "Class methods" do
  include SeleniumTestCaseSpec
  it "should maintain a subclass array" do
    test_class = Class.new
    test_class.extend SeleniumrcFu::SeleniumTestCase::ClassMethods

    subclass1 = Class.new(test_class)
    subclass2 = Class.new(test_class)

    test_class.subclasses.should ==  [subclass1, subclass2]
  end

  it "should not use transactional fixtures by default" do
    SeleniumrcFu::SeleniumTestCase.use_transactional_fixtures.should ==  false
  end

  it "should use instantiated fixtures by default" do
    SeleniumrcFu::SeleniumTestCase.use_instantiated_fixtures.should ==  true
  end

  class Parent < SeleniumrcFu::SeleniumTestCase
  end
  class Child1 < Parent
  end
  class Child2 < Parent
  end
  class Grandchild1 < Child1
  end
  class Grandchild2 < Child2
  end
  class Grandchild3 < Child2
  end

  it "should recursively gather all subclasses" do
    Parent.all_descendant_classes.should == ([Child1, Grandchild1, Child2, Grandchild2, Grandchild3])
  end
end
end
