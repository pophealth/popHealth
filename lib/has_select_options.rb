#
# This module extends ActiveRecord::Base with a single class method: has_select_options().
# When you call this method on an ActiveRecord class it will generate the class method select_options().
#
# - This is meant to be used with models whose records are used as the choices in a select dropdown.
# - You can pass finder options to filter or change the order.
# - You can change the generated method name, useful if you need multiple methods
# - You can pass a block to change the output of select_options. The block argument is a single record.
# - The output of select_options can be passed to a form.select helper.
# - You can explicitly pass an array of objects that you'd like to select from instead.
# - You can prefix the method with html_ to get HTML output for use with select_tag
#
# By default, select_options will select all records sorted by name ascending.
# The default output for each record is [name, id].
# You can specify a label_column to use instead of name.
#
# Examples:
#
#  class IsoCountry
#    # use the default order and output
#    has_select_options
#  end
#  IsoCountry.select_options # => [["Afghanistan", 480326053], ... ["Zimbabwe", 809220305]]
#
#  class IsoState
#    # use a different order and output from the defaults
#    has_select_options(:order => 'iso_abbreviation ASC') {|r| r.iso_abbreviation }
#  end
#  IsoState.select_options # => ['AK', 'AL', ... 'WV', 'WY']
#
#  class User
#    # use a different column for the option label instead of name
#    has_select_options :label_column => :display_name
#  end
#  User.select_options # => [["Harry Manchester", 12], ... ["Bob Roberts", 23]]
#
#  class CodeSystem
#    # multiple methods
#    has_select_options :method_name => :select_options
#    has_select_options :method_name => :medication_select_options,
#     :order => "name DESC",
#     :conditions => {
#       :code => [ # performs a SQL IN
#         '2.16.840.1.113883.6.88',  # RxNorm
#         '2.16.840.1.113883.6.69',  # NDC
#         '2.16.840.1.113883.4.9',   # FDA Unique Ingredient ID (UNIII)
#         '2.16.840.1.113883.4.209'  # NDF RT
#       ]
#     }
#  end
#
module HasSelectOptionsExtension
  def has_select_options(args = {})
    (class << self; self; end).instance_eval do
      method_name = args.delete(:method_name) || :select_options
      label_column = args.delete(:label_column) || :name
      define_method(method_name) do |*x|
        (x.size > 0 ? x[0] : find(:all, { :order => 'name ASC' }.merge(args))).map do |r|
          block_given? ? yield(r) : [r.send(label_column), r.id]
        end
      end
      define_method("html_#{method_name}") do |*x|
        send(method_name, *x).map { |r| %{ <option value="#{r[1]}">#{r[0]}</option> } }
      end
    end
  end
end

