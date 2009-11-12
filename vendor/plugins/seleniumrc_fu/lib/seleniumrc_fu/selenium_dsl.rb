module SeleniumrcFu
  module SeleniumDsl
    # The default time in seconds a wait_for method will poll until raising an error.
    def default_wait_for_time
      5
    end

    def type(locator,value)
      assert_element_present locator
      selenium.type(locator,value)
    end

    def click(locator)
      assert_element_present locator
      selenium.click(locator)
    end

    alias_method :wait_for_and_click, :click

    # Download a file from the Application Server
    def download(path)
      uri = URI.parse(context.browser_url + path)
      puts "downloading #{uri.to_s}"
      Net::HTTP.get(uri)
    end

    def select(select_locator,option_locator)
      assert_element_present select_locator
      selenium.select(select_locator,option_locator)
    end

    # Reload the current page that the browser is on.
    def reload
      selenium.get_eval("selenium.browserbot.getCurrentWindow().location.reload()")
    end

    # The default Selenium Core client side timeout.
    def default_timeout
      @default_timeout ||= 20000
    end
    attr_writer :default_timeout

    def method_missing(name, *args)
      return selenium.send(name, *args)
    end


#--------- Commands

    # Open a location and wait for the page to load.
    def open_and_wait( location)
      selenium.open(location)
      wait_for_page_to_load
    end

    # Click a link and wait for the page to load.
    def click_and_wait(locator, wait_for = default_timeout)
      selenium.click locator
      wait_for_page_to_load(wait_for)
    end

    # Click the back button and wait for the page to load.
    def go_back_and_wait
      selenium.go_back
      wait_for_page_to_load
    end

    # Open the home page of the Application and wait for the page to load.
    def open_home_page
      selenium.open(context.browser_url)
      wait_for_page_to_load
    end

    # Get the inner html of the located element.
    def get_inner_html(locator)
      selenium.get_eval("this.page().findElement(\"#{locator}\").innerHTML")
    end

    # Does the element at locator contain the text?
    def element_contains_text(locator, text)
      selenium.is_element_present(locator) && get_inner_html(locator).include?(text)
    end

    # Does the element at locator not contain the text?
    def element_does_not_contain_text(locator, text)
      return true unless selenium.is_element_present(locator)
      return !get_inner_html(locator).include?(text)
    end


#------ Assertions and Conditions

    # Assert and wait for the locator element to have value.
    def assert_value(locator, value)
      assert_element_present locator
      wait_for do |context|
        actual = selenium.get_value(locator)
        context.message = "Expected '#{locator}' to be '#{value}' but was '#{actual}'"
        value == actual
      end
    end

    # Assert and wait for the locator attribute to have a value.
    def assert_attribute(locator, value)
      assert_element_present locator
      wait_for do |context|
        actual = selenium.get_attribute(locator)  #todo: actual value
        context.message = "Expected attribute '#{locator}' to be '#{value}' but was '#{actual}'"
        value == actual
      end
    end

    # Assert and wait for the page title.
    def assert_title(title, params={})
      wait_for(params) do |context|
        actual = selenium.get_title
        context.message = "Expected title '#{title}' but was '#{actual}'"
        title == actual
      end
    end

    # Assert and wait for locator select element to have value option selected.
    def assert_selected(locator, value)
      assert_element_present locator
      wait_for do |context|
        actual = selenium.get_selected_label(locator)
        context.message = "Expected '#{locator}' to be selected with '#{value}' but was '#{actual}"
        value == actual
      end
    end

    # Assert and wait for locator check box to be checked.
    def assert_checked(locator)
      assert_element_present locator
      wait_for(:message => "Expected '#{locator}' to be checked") do
        selenium.is_checked(locator)
      end
    end

    # Assert and wait for locator check box to not be checked.
    def assert_not_checked(locator)
      assert_element_present locator
      wait_for(:message => "Expected '#{locator}' not to be checked") do
        !selenium.is_checked(locator)
      end
    end

    # Assert and wait for locator element to have text equal to passed in text.
    def assert_text(locator, text, options={})
      assert_element_present locator
      wait_for(options) do |context|
        actual = selenium.get_text(locator)
        context.message = "Expected text '#{text}' to be full contents of #{locator} but was '#{actual}')"
        text == actual
      end
    end

    # Assert and wait for page to contain text.
    def assert_text_present(pattern, message = "Expected '#{pattern}' to be present, but it wasn't", options = {})
      wait_for({:message => message}.merge(options)) do
         selenium.is_text_present(pattern)
      end
    end

    # Assert and wait for page to not contain text.
    def assert_text_not_present(pattern, message = "Expected '#{pattern}' to be absent, but it was present", options = {})
      wait_for({:message => message}.merge(options)) do
         !selenium.is_text_present(pattern)
       end
    end

    # Assert and wait for locator element to not be present.
    def assert_element_not_present(locator)
      wait_for(:message => "Expected element '#{locator}' not to be present, but it was") do
        !selenium.is_element_present(locator)
      end
    end

    # Assert and wait for locator element to be present.
    def assert_element_present(locator, params = {})
      params = {:message => "Expected element '#{locator}' to be present, but it was not"}.merge(params)
      wait_for(params) do
       selenium.is_element_present(locator)
     end
    end

    # Assert and wait for locator element to contain text.
    def assert_element_contains(locator, text, message=nil)
      actual_message = "#{locator} should contain #{text}"
      actual_message = message + ": " + actual_message unless message.nil?
      wait_for(:message => actual_message) do
        element_contains_text(locator, text)
      end
    end

    # Assert and wait for locator element to not contain text.
    def assert_element_does_not_contain_text(locator, text, message=nil, timeout=default_wait_for_time)
      wait_for({:message => message, :timeout => timeout}) {element_does_not_contain_text(locator, text)}
    end
    alias_method :assert_element_does_not_contain, :assert_element_does_not_contain_text
    alias_method :wait_for_element_to_not_contain_text, :assert_element_does_not_contain_text

    # Assert and wait for the element with id next sibling is the element with id expected_sibling_id.
    def assert_next_sibling(id, expected_sibling_id)
      wait_for(:message => "id '#{id}' should be next to '#{expected_sibling_id}'") do
        actual_sibling_id = get_eval("this.page().findElement('#{id}').nextSibling.id")
        expected_sibling_id == actual_sibling_id
      end
    end

    # Assert browser url ends with passed in url.
    def assert_location_ends_in(url)
      expected_url_base, expected_url_parameters = url.split('?')
      actual_url_base, actual_url_parameters = selenium.get_location.split('?')
      assert_match /#{Regexp.escape(expected_url_base)}$/, actual_url_base
      actual_parameters = actual_url_parameters.nil? ? nil : actual_url_parameters.split("&")
      expected_parameters = expected_url_parameters.nil? ? nil : expected_url_parameters.split("&")
      if actual_parameters.nil? || expected_parameters.nil?
        assert_equal expected_parameters, actual_parameters
      else
        assert_equal expected_parameters.sort, actual_parameters.sort
      end
    end

    # Assert and wait for locator element has text fragments in a certain order.
    def assert_text_in_order(locator, *text_fragments)
      wait_for do |context|
        success = true
        is_text_in_order(locator, *text_fragments) do |everything_found, wasnt_found_message, everything_in_order, wasnt_in_order_message|
          success = false
          if everything_found
            context.message = wasnt_in_order_message
          else
            context.message = wasnt_found_message
          end
        end
        success
      end
    end
    alias_method :wait_for_text_in_order, :assert_text_in_order

    # Does locator element have text fragments in a certain order?
    def is_text_in_order(locator, *text_fragments)
      container = Hpricot(get_text(locator))

      everything_found = true
      wasnt_found_message = "Certain fragments weren't found:\n"

      everything_in_order = true
      wasnt_in_order_message = "Certain fragments were out of order:\n"

      text_fragments.inject([-1, nil]) do |old_results, new_fragment|
        old_index = old_results[0]
        old_fragment = old_results[1]
        new_index = container.inner_html.index(new_fragment)

        unless new_index
          everything_found = false
          wasnt_found_message << "Fragment #{new_fragment} was not found\n"
        end

        if new_index < old_index
          everything_in_order = false
          wasnt_in_order_message << "Fragment #{new_fragment} out of order:\n"
          wasnt_in_order_message << "\texpected '#{old_fragment}'\n"
          wasnt_in_order_message << "\tto come before '#{new_fragment}'\n"
        end

        [new_index, new_fragment]
      end

      wasnt_found_message << "\n\nhtml follows:\n #{container.inner_html}\n"
      wasnt_in_order_message << "\n\nhtml follows:\n #{container.inner_html}\n"

      unless everything_found && everything_in_order
        yield(everything_found, wasnt_found_message, everything_in_order, wasnt_in_order_message)
      end
    end

#----- Waiting for conditions

    def wait_for_page_to_load(timeout=default_timeout)
      selenium.wait_for_page_to_load timeout
      if get_title.include?("Exception caught")
        fail "We got a new page, but it was an application exception page.\n\n" + get_html_source
      end
      assert !(get_title.include?("Exception caught")), "We got a new page, but it was an application exception page."
    end

    def assert_visible(pattern, message = "Expected '#{pattern}' to be visible, but it wasn't", options = {})
      wait_for({:message => message}.merge(options)) do
        selenium.is_visible(pattern)
      end
    end

    def assert_not_visible(pattern, message = "Expected '#{pattern}' to be not visible, but it was visible", options = {})
      wait_for({:message => message}.merge(options)) do
        !selenium.is_visible(pattern)
      end
    end

    def click_and_wait_for_page_to_load(locator)
       click locator
       wait_for_page_to_load
    end

    Context = Struct.new(:message)

    # Poll continuously for the return value of the block to be true. You can use this to assert that a client side
    # or server side condition was met.
    #   wait_for do
    #     User.count == 5
    #   end
    def wait_for(params={})
      timeout = params[:timeout] || default_wait_for_time
      message = params[:message] || "Timeout exceeded"
      context = Context.new(message)
      begin_time = time_class.now
      while (time_class.now - begin_time) < timeout
        return if yield(context)
        sleep 0.25
      end
      flunk(context.message + " (after #{timeout} sec)")
    end

    def wait_for_element_to_contain(locator, text, message=nil, timeout=default_wait_for_time)
      wait_for({:message => message, :timeout => timeout}) {element_contains_text(locator, text)}
    end
    alias_method :wait_for_element_to_contain_text, :wait_for_element_to_contain

    # Open the log window on the browser. This is useful to diagnose issues with Selenium Core.
    def show_log(log_level = "debug")
      get_eval "LOG.setLogLevelThreshold('#{log_level}')"
    end

    # Slow down each Selenese step after this method is called.
    def slow_mode
      get_eval "slowMode = true"
      get_eval 'window.document.getElementsByName("FASTMODE")[0].checked = true'
    end

    # Speeds up each Selenese step to normal speed after this method is called.
    def fast_mode
      get_eval "slowMode = false"
      get_eval 'window.document.getElementsByName("FASTMODE")[0].checked = false'
    end

    protected
    attr_accessor :selenium
    delegate :open,
             :wait_for_condition,
             :get_select_options,
             :get_selected_id,
             :get_selected_id,
             :get_selected_ids,
             :get_selected_index,
             :get_selected_indexes,
             :get_selected_label,
             :get_selected_labels,
             :get_selected_value,
             :get_selected_values,
             :get_body_text,
             :get_html_source,
             :to => :selenium

    def time_class
      Time
    end    
  end
end