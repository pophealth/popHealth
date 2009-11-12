module SeleniumrcFu
  module SeleniumCharacterization
    def self.included(base)
      Dispatcher.register(CssCharacterizer)
    end
    
    class CssCharacterizer
      attr_accessor :expected_hash, :actual_hash, :differences_hash1, :differences_hash2
      
      def initialize(test_class, store_dirname)
        @test_class    = test_class
        @store_dirname = store_dirname
        FileUtils.mkdir_p(@store_dirname)
      end
      
      def store(selenium)
        @selenium = selenium
        dump_calculated_styles(page_name)
      end
      
      def compare(selenium)
        @selenium = selenium
        assert_calculated_styles(page_name)
      end
      
      private
      
      def page_name
        result = @selenium.get_eval('selenium.browserbot.getCurrentWindow().location.pathname')[1..-1]
        result = 'index' if result.blank?
        result.gsub!(/[^a-zA-Z0-9]/, "_")
        result
      end

      def assert_calculated_styles(intended)
        if intended.is_a?(String)
          intended = load_calculated_styles(intended)
        end
      
        assert_css_equal intended, get_element_style_by_xpath('//*')
      end
      
      def assert_css_equal(expected_hash, actual_hash)
        comparator = Comparator.new(expected_hash, actual_hash)
        @test_class.assert comparator.compare, comparator.failure_message
      end
      
      def load_calculated_styles(filename)
        YAML.load(File.open(File.join(@store_dirname, *%W[#{filename}.yml]), 'r'))
      end
      
      def dump_calculated_styles(filename)
        File.open(File.join(@store_dirname, *%W[#{filename}.yml]), 'w') do |f|
          f << YAML.dump(get_element_style_by_xpath('//*'))
        end
      end
      
      def get_element_style_by_xpath(xpath)
        eval(@selenium.get_eval("selenium.getStyles('#{xpath}');"))
      end

      class Comparator
        def initialize(expected_hash, actual_hash)
          @expected_hash     = expected_hash
          @actual_hash       = actual_hash
          @differences_hash1 = {}
          @differences_hash2 = {}
        end
      
        def compare
          mismatched_html_elements1 = @expected_hash.select { |html_element, css_style| css_style != @actual_hash[html_element] }
          mismatched_html_elements1.each do |html_css_pair|
            html_element, css_style = *html_css_pair
            @differences_hash1[html_element] = css_style.select { |css_name, css_value| ( ! @actual_hash[html_element].nil?) && @actual_hash[html_element][css_name] != css_value }
          end
      
          mismatched_html_elements2 = @actual_hash.select { |html_element, css_style| css_style != @expected_hash[html_element] }
          mismatched_html_elements2.each do |html_css_pair|
            html_element, css_style = *html_css_pair
            @differences_hash2[html_element] = css_style.select { |css_name, css_value| ( !@expected_hash[html_element].nil?) && @expected_hash[html_element][css_name] != css_value }
          end
      
          @differences_hash1.empty? && @differences_hash2.empty?
        end
      
        def pretty_print_value(value)
          return 'element without styles' if value.size == 0
      
          result = ""
          value.each do |x|
            result += "\n  #{x.inspect}"
          end
          return result
        end
      
        def failure_message
          message =  "\nThe style for these html elements differed as follows:"
      
          @differences_hash1.each_pair do |key, value|
            message += "\nexpected..."
            message += "\n#{key} => #{pretty_print_value(value)}"
            message += "\nfound..."
      
            if @differences_hash2.has_key?(key)
              message += "\n#{key} => #{pretty_print_value(@differences_hash2[key])}"
            else
              message += "\n#{key} => element missing"
            end
            message += "\n"
          end
      
          @differences_hash2.each_pair do |key, value|
            unless @differences_hash1.has_key?(key)
              message += "\nexpected..."
              message += "\n#{key} => element missing"
      
              message += "\nfound..."
              message += "\n#{key} => #{pretty_print_value(value)}"
              message += "\n"
            end
          end
      
          return message
        end
      end
    end
  end
end
