module Funkytown
  class JsunitTestPage
    attr_accessor :test_page

    def initialize(test_page, path_to_test_pages)
      if (test_page !~ /\./)  # no file extension
        test_page = test_page + ".html"
      end
      @test_page = test_page
      @path_to_test_pages = path_to_test_pages
    end

    def name
      "jsunit_" + clean.gsub(/\.html$/, '').gsub(/\//, '_')
    end

    def clean
      regex = Regexp.new("^.*#{@path_to_test_pages}/")  # match everything up to path...
      test_page.gsub(regex, '')                         # ...and remove it
    end

    def path
      "#{@path_to_test_pages}/#{clean}"
    end

    def path_on_disk
      Funkytown::System.consolidate_path("#{SYSTEM.root}/public/#{path}")
    end
  end
end