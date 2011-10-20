module ApplicationHelper
  
  def render_js(options = nil, extra_options = {}, &block)
    escape_javascript(render(options, extra_options, &block))
  end
end
