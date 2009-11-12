 require 'rexml/document'
 require 'active_support/inflector'
 
 class SeleniumConvert
   def initialize(text)
     text.gsub!(/<br>/, "<br/>")
     @doc = REXML::Document.new(text)
   end
   
   def to_ruby
     return "" if !@doc.root
     
     commands = ""
     @doc.root.elements.each("//table/tbody") do |tbody|
       tbody.elements.each("tr") do |row|
         args = []
         row.elements.each("td") do |cell|
           text = cell.get_text.to_s.strip
           unless(text == "&nbsp;" || text == "")
             args << text
           end
         end
         
         if !args.empty?
           command = "  "
           command << Inflector.underscore(args[0])
           
           params = []
           args[1..args.length].each do |arg|
             params << " '" + arg.gsub(/'/, "\\\\'") + "'"
           end
           
           commands << command
           commands << params.join(",")
           commands << "\n"
         end
       end
     end
     
     return commands
   end
   
   def self.test_name(arg)
     arg = arg.chomp('.html')
     arg = arg.split("/").last
    "test_" + Inflector.underscore(arg)
   end
   
 end
 
 ARGV.each do |arg|
   puts "# USAGE USAGE USAGE"
   puts "#    cd public/selenium/[your test dir]"
   puts "#    ls | xargs ruby ../../../vendor/plugins/seleniumrc_fu/tools/selenium_convert.rb"
   puts "\n\n"
   puts "def " + SeleniumConvert.test_name(arg)
   File.open(arg) do |file|
     xml = ""
     while line = file.gets
       xml << line
     end
     puts SeleniumConvert.new(xml).to_ruby
   end
   puts "end"
 end
 
