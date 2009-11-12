require 'sort_order'
module TestPlansHelper
  include SortOrderHelper

  def plan_when_tested plan
      plan.pending? ? 'not yet tested' : "#{time_ago_in_words plan.updated_at} ago"
  end

  def action_list_items test_plan, opts
    test_plan.test_actions.map do |k, v|
      if k =~ />$/
        content_tag 'li',
          link_to_remote(k[0..-2], :url => {
            :controller => 'test_plans', :action => v, :id => test_plan
          }, :update => opts[:update])
      else
        content_tag 'li',
          link_to(k, :controller => 'test_plans', :action => v, :id => test_plan)
      end
    end
  end

  # method used to mark the elements in the document that have errors so they 
  # can be linked to
  def match_errors(errors, doc)
    error_map = {}
    error_id = 0
    @error_attributes = []
    locs = errors.collect{|e| e.location}
    locs.compact!

    locs.each do |location|
      node = REXML::XPath.first(doc ,location)
      if(node)
        elem = node
        if node.class == REXML::Attribute
          @error_attributes << node
          elem = node.element
        end
        if elem
          unless elem.attributes['error_id']
            elem.add_attribute('error_id',"#{error_id}") 
            error_id += 1
          end
          error_map[location] = elem.attributes['error_id']
        end
      end
    end

    error_map
  end

  def xds_metadata_single_attribute(metadata, attribute)
    "<tr>
      <td><strong>#{attribute.to_s.humanize}</strong></td>
      <td>#{metadata.send(attribute)}</td>
      <td></td>
    </tr>"
  end
  
  def xds_metadata_coded_attribute(metadata, attribute)
    "<tr>
      <td><strong>#{attribute.to_s.humanize}</strong></td>
      <td><strong>Display name</strong></td>
      <td>#{metadata.send(attribute).display_name}</td>
    </tr>
    <tr>
      <td></td>
      <td><strong>Code</strong></td>
      <td>#{metadata.send(attribute).code}</td>
    </tr>
    <tr>
      <td></td>
      <td><strong>Coding Scheme</strong></td>
      <td>#{metadata.send(attribute).coding_scheme}</td>
    </tr>
    <tr>
      <td></td>
      <td><strong>Classification Scheme</strong></td>
      <td>#{metadata.send(attribute).classification_scheme}</td>
    </tr>"
  end
end
