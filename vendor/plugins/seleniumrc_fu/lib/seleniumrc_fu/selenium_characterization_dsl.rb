module SeleniumrcFu
  module SeleniumCharacterizationDsl
    
    def self.included(base)
      base.class_eval do
        # wait_for_page_to_load
        alias_method :wait_for_page_to_load_without_characterization, :wait_for_page_to_load unless method_defined?(:wait_for_page_to_load_without_characterization)
        alias_method :wait_for_page_to_load, :wait_for_page_to_load_with_characterization

        # wait_for
        alias_method :wait_for_without_characterization, :wait_for unless method_defined?(:wait_for_without_characterization)
        alias_method :wait_for, :wait_for_with_characterization
      end
    end

    def wait_for_page_to_load_with_characterization(timeout=default_timeout)
      wait_for_page_to_load_without_characterization
      characterization_dispatch
    end
    
    def wait_for_with_characterization(params = {}, &block)
      wait_for_without_characterization(params, &block)
      characterization_dispatch
    end
    
    private
    
    def characterization_dispatch
      if characterization_enabled?
        SeleniumrcFu::SeleniumCharacterization::Dispatcher.dispatch(context, selenium, self)
      end
    end

  end
end