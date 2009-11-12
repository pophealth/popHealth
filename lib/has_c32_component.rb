#
# This module extends ActiveRecord::Base with a class method has_c32_component.
# It's used in Patient (and potentially elsewhere) to declare dependent c32
# submodules.
#
#  has_many_c32 :medications
#
# is mostly equivalent to:
#
#  has_many :medications, :dependent => :destroy
#
# However, the medications association has a method to_c32 that
# will aggregate the results of calling to_c32 on each record. Additionally,
# if the Medication class has a class method c32_component it will be used
# to render surrounding boilerplate using a passed XML builder object.
#
# NOTE that the c32_component method (if present) MUST yield the passed xml
# builder to render each record's c32.
#
# has_one_c32 doesn't include any functionality related to C32 generation,
# it's just there to document which associations are c32-related. It also
# causes dependents to be destroyed on deletion.
#
module HasC32ComponentExtension
  def has_many_c32(rel, args = {})
    has_many rel, args.merge(:extend => C32Component, :dependent => :destroy)
  end

  def has_one_c32(rel, args = {})
    has_one rel, args.merge(:dependent => :destroy)
  end

  module C32Component
    def to_c32(xml)
      if proxy_reflection.klass.respond_to? :c32_component
        proxy_reflection.klass.c32_component(self, xml) { map {|r| r.to_c32(xml)} }
      else
        map {|r| r.to_c32(xml)}
      end
    end
  end
end

