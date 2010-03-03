# creates a data grid from enumerable data.  
#
# paginated data must be wrapped UI::PaginatedResults
# 
# in the view, usage might look like the following.
# <code>
#   <%= grid(@results, :name => 'patients').columns { |g|
# =>  g.column :name
# =>  g.column :age
# =>  g.column 'registration_information.race.name', :title => 'Race'
#   } %>
# </code>
def grid(enumerable, options ={}, &block)
  # todo: get around the tacky way of including the controller in this manner
  if !enumerable.respond_to? :total
    enumerable = UI::PaginatedResults.new enumerable
  end
  ui_grid = UI::Grid.new(enumerable, @controller, options)
  yield ui_grid if block_given?
  return ui_grid
end

module UI
  
  # Simple Data Grid View for data that is enumerable and wrapped into 
  # UI:PaginatedResults.
  #
  #   
  # todo: seriously refactor and get a code review.
  # todo: make active record mixins for handling paging/sorting.  
  class Grid
    attr_accessor :columns, :output, :data, :name, :type, :empty_template, :classes
    attr_accessor :actions, :show_action, :edit_action, :delete_action, :sort_action, :page_action
    attr_accessor :empty_action, :attributes

    def initialize(enumerable, controller, options={})
      @attributes = Hash.new
      @data = enumerable
      @controller = controller
      ensure_name(options)
      @classes = String.new
      
      options.each do |k,v|
        instance_variable_set('@' + k.to_s, v)
      end
      
      @page_action = nil

   
      @columns = ColumnList.new
      @output = String.new
    end
    
    # defines the columns that are to be created for the grid.
    def columns(&block)
      yield @columns
      return self
    end
    
    # used to indent the grid in the html source
    def indent(tabs)
      @tab = ""
      tabs.times { |i| @tab << "\t" }
      return self
    end
    
    # tells the grid to have 'show' action, in the actions column.
    def show(options = {})
      if @data.length > 0
        default = {:url => "/" + @type.pluralize.downcase + "/show/:id", :text => "show"}
        @show_action = default.merge(options)
        @actions = true
      end
      return self
    end
    
    def empty()
      @empty_action = true
      return self
    end
    
    # instructs the grid to use pagination for the result set.
    def page(options = {})
      if(@data.length > 0)
        default = {:url => "/" + @type.pluralize.downcase + "/list/?", :text => "", :bottom => true, :top => false}
        @page_action = default.merge(options)
        @actions = true   
      end
      return self   
    end
    
    # renders the grid.
    def render
      output = ""
      attributes = ""
      css_classes = "midori-ui-control midori-bind-grid "  + @classes
      @attributes[:class] = css_classes
      
      @attributes.each do |k,v|
        attributes << " #{k}=\"#{v}\""
      end
      
      output << "#{@tab}<div id=\"#{@name}\" #{attributes}>"
      
      if @empty_action && @data.length == 0
        output << render_empty_template
      else
        output << render_table
      end
      
      output << "#{@tab}</div>"
      return output
    end
    
    # renders the template for when there are no results.
    def render_empty_template
      @empty_template ||= "<p> Sorry there were no records found. </p>"
      return @empty_template
    end
    
    # 
    def params
      return @controller.params
    end
    
    # renders the table.  
    def render_table
      @type ||= ""
      
      output << <<-EOF
      <!-- grid -->
#{@tab} <table cellpadding="0" summary="grid view for #{@type.pluralize.titleize}">
#{@tab}   <caption>
#{render_caption}
#{@tab}   </caption>
#{render_header}
#{render_body}
#{render_footer}
#{@tab} </table>
      EOF
      return output
    end
    
    def render_caption
      pagination = ""
      
      if @page_action && @page_action[:top]
        pagination = render_pagination
      end
      
      return "<span class='title'>#{@type.pluralize.titleize}</span> (<span class='count'>#{@data.total}</span>) #{pagination}"
    end
    
    def find_value(item, path)
      if path.include? "."
        obj = item
        methods = path.split "."
        methods.each do |method_name|
          if obj.respond_to? method_name
            obj = obj.__send__ method_name
          else
            obj = obj.instance_variable_get "@#{method_name}"
          end
        end
        return obj
      else 
        if item.respond_to? path
          return item.__send__ path
        else
          return item.instance_variable_get "@#{path}"
        end
      end
    end
    
    def render_header
      output = <<-EOF
#{@tab}   <thead>
#{@tab}     <tr>
      EOF
      
      if @actions == true
        output << "#{@tab}      <th class=\"actions\">&nbsp;</th>\n"
      end
    
      @columns.each do |c|
        output << "#{@tab}      <th class=\"#{c.name.dasherize}\">#{c.title}</th>\n"
      end

      output << <<-EOF
#{@tab}     </tr>
#{@tab}   </thead>
      EOF
      
      return output
    end
    
    
    def render_body
      output = <<-EOF
#{@tab}   <tbody>
      EOF
      
      will_show = !@show_action.nil?
      return_url = false
      
      if !@page_action.nil?
        prefix = "#{@name.dasherize.downcase}-pagination"
        link = @page_action[:url]
        return_url = CGI.escape "#{link}#{prefix}[sort]=#{@data.sort}&#{prefix}[page]=#{@data.page}&#{prefix}[page_size]=#{@data.page_size}"
      end
      
      if  will_show && @show_action[:url].include?(":return")
        @show_action[:url] = @show_action[:url].sub(/\:\breturn\b/, return_url)
      end
      
      count = 1
      @data.each do |item|
        css_class = count % 2 == 0 ? "alt" : ""
        count = count + 1
        output << "#{@tab}      <tr class=\"#{css_class}\">\n"
        if @actions == true
          output << "#{@tab}        <td class=\"actions\">"
          if !@show_action.nil?
            show_url = @show_action[:url].sub(/\:\bid\b/, item.id.to_s)
            output << "<a class='action show' href='#{show_url}'>#{@show_action[:text]}</a>"
          end
          output << "</td>\n"
        end
        @columns.each do |c|
          value = find_value item, c.path
            if !c.format.nil?
              value = c.format.call(value, item)
            end
          output << "#{@tab}        <td class=\"#{c.name.dasherize}\">#{value}</td>\n"
        end
        output << "#{@tab}      </tr>\n"
      end

      output << <<-EOF
#{@tab}   </tbody>
      EOF
      
      return output
    end
    
    
    def render_footer
      length = @columns.length
      if @actions == true
        length = length + 1
      end
      
      pagination = "&nbsp;"
      
      if @page_action && @page_action[:bottom]
        pagination = render_pagination
      end
      
      output = <<-EOF
#{@tab}   <tfoot>
#{@tab}     <tr>
#{@tab}       <td colspan=\"#{length}\">
#{pagination}
#{@tab}       </td>
#{@tab}     </tr>
#{@tab}   </tfoot>
      EOF
      return output
    end
    
    def create_link()
      @data.sort  
      
    end
    
    def url_encode_options
    end
    
    def render_pagination
      if !@page_action.nil?
        prefix = "#{@name.dasherize.downcase}-pagination"
        link = @page_action[:url]
        inputs = ""
        @page_action[:params].each do |k,v|
            link = link + "#{k}=#{CGI.escape(v)}&amp;"
            inputs = inputs + "<input type='hidden' name='#{k}' value=\"#{v}\" /> "
        end
        query = "#{link}#{prefix}[sort]=#{@data.sort}"
        
       
        
  
        output = "#{@tab}         <div class=\"pagination\">"
        if @data.previous?
          output << "<a class=\"first\" title=\"go to the first page\""
          output << "  href=\"#{query}&amp;#{prefix}[page]=1&amp;#{prefix}[page_size]=#{@data.page_size}\"> &lt;&lt; </a>"
          output << "<a class=\"previous\" title=\"go to the previous page\" "
          output << "href=\"#{query}&amp;#{prefix}[page]=#{@data.previous}&amp;#{prefix}[page_size]=#{@data.page_size}\"> &lt; </a>"
        else
          output << "<span class=\"first\"> &lt;&lt; </span>"
          output << "<span class=\"previous\"> &lt; </span>"
        end
  
        output << "<form method=\"GET\" class=\"current-page\" action=\"#{query}&amp;#{prefix}[page_size]=#{@data.page_size}\">"
        output << "<div><label>page</label>"
        output << "<input class=\"text\" type=\"text\" name=\"#{prefix}[page]\" value=\"#{@data.page}\" />"
        output << "<input type=\"hidden\" name=\"#{prefix}[page_size]\" value=\"#{@data.page_size}\" />"
        output << "<input type=\"hidden\" name=\"#{prefix}[sort]\" value=\"#{@data.sort}\" />"
        output << inputs
        output << "<span class=\"pages\">of <span class=\"count\">#{@data.pages}</span></span>"
        output << "<input type=\"submit\" value=\"change\" /> </div> "
        output << "</form>"
  
        if @data.next?
          output << "<a class=\"next\" title=\"go to the next page\" "
          output << "href=\"#{query}&amp;#{prefix}[page]=#{@data.next}&amp;#{prefix}[page_size]=#{@data.page_size}\"> &gt; </a>"
          output << "<a class=\"last\" title=\"go to the last page\""
          output << "  href=\"#{query}&amp;#{prefix}[page]=#{@data.pages}&amp;#{prefix}[page_size]=#{@data.page_size}\"> &gt;&gt; </a>"
        else
          output << "<span class=\"next\"> &gt; </span>"
          output << "<span class=\"last\"> &gt;&gt; </span>"
        end
  
        output << "<form method=\"GET\" class=\"page-size\" action=\"#{query}&amp;#{prefix}[page]=#{@data.page}\">"
        output << "<div><label>rows displayed</label>"
        output << "<input type=\"hidden\" name=\"#{prefix}[page]\" value=\"#{@data.page}\" />"
        output << "<input type=\"hidden\" name=\"#{prefix}[sort]\" value=\"#{@data.sort}\" />"
        output << inputs
        sizes = [5,10,15,25]
        output << "<select name=\"#{prefix}[page_size]\">"
        sizes.each do |row|
          selected = @data.page_size == row ? " selected=\"selected\"" : ""
          output << "<option value=\"#{row}\"#{selected}>#{row}</option>"
        end
        output << "</select><input type=\"submit\" value=\"change\"></div></form>"
        return output
      end
    
      return "          &nbsp;"
    end
    

    def to_s
      return render
    end
  
    :private 
    
    def ensure_name(options)
      if options[:name].nil?
        if !options[:type].nil?
          @type = options[:type].to_s
        elsif @data.length > 0
          @type = @data.first.class.name
        else
          raise "you must include the object type or a name for the grid."
        end
        @name = @type.dasherize + "-grid"
      else
        if options[:type].nil? && @data.length > 0
          @type = @data.first.class.name
        end
      end
    end
    
  end
  
    
  class PaginatedResults
    attr_accessor :total, :page, :page_size, :pages, :sort
    
    #constructor.
    def initialize(enumerable, total = nil, page = 1, page_size = 25, sort = nil)
      @enumerable = enumerable
      @sort = sort
      calculate(total || enumerable.length, page, page_size)
    end
    
    # gets the page number for the page after the current one.
    def next
      return @page + 1
    end

    # determines if current page has another page after it.
    def next?
      return @pages > @page
    end
    #alias :next :has_next

    # gets the number of previous page.
    def previous
      return @page - 1
    end

    # determines if the current page has a prevous page. 
    def previous?
      return @page > 1
    end
    #alias :previous? :has_previous
    
    # gets the underlying result set
    def list
      return @enumerable
    end
    
    # enumerates over the underlying result set
    def each(&block)
      list.each &block
    end
    
    #  gets the first object in the result set.
    def first
      @enumerable.first
    end
    
    # gets the last object in the result set.
    def last
      @enumerable.last
    end
    
    # gets the length/size of the result set
    def length
      @enumerable.length
    end
    
    # gets the default page size, which is a global default setting 
    def self.default_page_size
      @@default_page_size ||= 25
      return @@default_page_size
    end
    
    # sets the default page size, which is a global default setting
    def self.default_page_size=(value)
      @@default_page_size = value
    end
    

    # merges the options with the limit and offset values
    # that are required for pagination
    def self.wrap(name, parameters, &block)
       options = options || {}
        page_options = parameters[name.to_s.dasherize().downcase + "-pagination"]  || Hash.new  
        page = 1
        page_size = default_page_size
        sort = ""
        
        if page_options.key? :page
          page = page_options[:page].to_i
          if page < 1 
            page =  1
          end
        end   
        
        if page_options.key? :page_size
          page_size = page_options[:page_size].to_i
        end

        options = options.merge({:limit => page_size, :offset => (page -1) * page_size})
        
        if page_options.key? :sort && page_options[:sort] != ""
          options[:order] = page_options[:sort]
          sort = options[:order]
        end 

        results = yield options
        count = results[:count]
        

        return PaginatedResults.new(results[:data], results[:count], page, page_size, sort)
    end
  
    # calculate the number of pages, defaults the page size and page
    def calculate(total, page = 1, page_size = nil)
      @total = total
      @page_size = page_size || default_page_size
      @page = (!page.nil? && page > 0) ? page : 1
      
      pages = @total / @page_size
      
      @pages = pages.ceil < pages ? pages.ceil : pages.ceil + 1
    end
    
  end
  
  
  
  class ColumnList
    attr_reader :unique_key
    
    # constructor. 
    def initialize
      @list = Hash.new
      key "id"
    end
    
    # the primary key or unique identifier used to identify the row.
    def key(name)
      @unique_key = name
    end
    
    # gets the size/length of the underlying list of columns
    def length
      return @list.length
    end
    
    # enumerables through the underlying list of columns
    def each(&block)
      @list.each_value &block
    end
  
    # adds various number of columns to the listthat have the same default values
    def columns(names, options=nil)
      names.each  do |name|
        column name, options
      end
    end
    
    # adds a column to the list.
    def column(name, options = nil)
      column = Column.new(name, options)
      @list[name] = column
    end
  end
  
  class Column
    attr_accessor :name, :format, :title, :path, :sort
    
    
    def initialize(name, options = nil)
      options ||= Hash.new
      name = name.to_s
      @path = name
      if name.include? "."
        index = name.rindex(".") + 1
        length = (name.length - 1)
        @name = name.slice(index, length)
      else
        @name = name
      end
     
      @title = @name.titleize
      options.each do |k,v|
        __send__ "#{k}=", v
      end
    end 
    
  end
end