# Include this module in controllers that need to handle sorting.
#
# The sort specifier should be set using the :sort parameter. After the first
# use, the sort will be saved in the session for the current controller and
# action. When sort_order is called by the same controller and action in the
# same session, the results will include the previously specified sort order.
#
# To use this module:
#
#  require 'sort_order'
#  class SomeController < Application
#    include SortOrder
#    self.valid_sort_fields = %w[ field1 field2 ] # optional
#
#    def action
#      render :text => "requested sort is #{sort_order}"
#    end
#  end
#
# Then, in the helper:
#
#  require 'sort_order'
#  module SomeHelper
#    include SortOrderHelper
#  end
#
module SortOrder
  def self.included(klass)
    klass.class_eval do
      hide_action :sort_order
      hide_action :sort_spec
      include InstanceMethods
      extend ClassMethods
    end
  end

  # This provides a getter and setter for the class-wide valid_sort_fields accessor.
  # You can specify 
  module ClassMethods
    def valid_sort_fields=(value)
      @valid_sort_fields = value
    end
    def valid_sort_fields
      @valid_sort_fields
    end
  end

  module InstanceMethods
    # Get the requested sort order from the params or session. This is a string suitable for passing
    # to an activerecord finder as :order.
    def sort_order
      case sort_spec
      when /^\-([\w\.]+)$/
        invalid_sort_spec?($1) ? nil : "#{$1} DESC"
      when /^[\w\.]+$/
        invalid_sort_spec?(sort_spec) ? nil : "#{sort_spec} ASC"
      else
        nil
      end
    end

    # This is the accessor for the current sort specifier. It comes from the params or session.
    # The sort specifier is a string containing the identifier name, optionally preceded with a table (and a dot).
    # If there is a leading dash ("-") in the string the result sorts descending, otherwise it sorts ascending.
    def sort_spec
      session[session_sort_key] = params[:sort] || session[session_sort_key]
    end

    private
    def invalid_sort_spec?(sort)
      self.class.valid_sort_fields && !self.class.valid_sort_fields.include?(sort)
    end
    
    def session_sort_key
      "#{controller_name}:#{action_name}:sort".to_sym
    end
  end
end

module SortOrderHelper
  def sort_order_class(field_spec)
    if [ field_spec, "-#{field_spec}" ].include? controller.sort_spec
      controller.sort_spec.chars.first == '-' ? "selected sorted-descending" : "selected sorted-ascending"
    else
      "sortable"
    end
  end

  def link_to_sort(field_spec, label)
    sort_field = controller.sort_spec == field_spec ? "-#{field_spec}" : field_spec
    link_to content_tag(:div, label), "?sort=#{sort_field}"
  end
end

