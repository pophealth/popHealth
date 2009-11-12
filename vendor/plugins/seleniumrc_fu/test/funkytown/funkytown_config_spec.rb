require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "FunkytownConfig's load method" do
  before do
    @default = Funkytown::FunkytownConfig.default_config
  end

  it "should look for config files in appropriate places" do
    SYSTEM.stub!(:root).and_return("RAILSROOT")
    SYSTEM.stub!(:hostname).and_return("hostname")
    Funkytown::FunkytownConfig.machine_specific_filename.should == "RAILSROOT/config/funkytown/hostname.yml"
    Funkytown::FunkytownConfig.default_filename.should == "RAILSROOT/config/funkytown/default.yml"
  end

  it "should return default config if no config files exist" do
    Funkytown::FunkytownConfig.should_receive(:load_file).with(Funkytown::FunkytownConfig.machine_specific_filename).and_return({})
    Funkytown::FunkytownConfig.should_receive(:load_file).with(Funkytown::FunkytownConfig.default_filename).and_return({})
    Funkytown::FunkytownConfig.load.should == @default
  end

  it "should use hostname configs if the host.yml has stuff" do
    Funkytown::FunkytownConfig.should_receive(:load_file).with(Funkytown::FunkytownConfig.machine_specific_filename).and_return({:external_app_server_port => 4001})
    Funkytown::FunkytownConfig.should_receive(:load_file).with(Funkytown::FunkytownConfig.default_filename).and_return({})

    config = Funkytown::FunkytownConfig.load

    @default[:external_app_server_port].should == 4000
    config[:external_app_server_port].should == 4001

    @default[:internal_app_server_port].should == 4000
    config[:internal_app_server_port].should == 4000
  end

  it "should use default configs if the default.yml has stuff" do
    Funkytown::FunkytownConfig.should_receive(:load_file).with(Funkytown::FunkytownConfig.machine_specific_filename).and_return({})
    Funkytown::FunkytownConfig.should_receive(:load_file).with(Funkytown::FunkytownConfig.default_filename).and_return({:path_to_jsunit => "javascripts/jsunit"})

    config = Funkytown::FunkytownConfig.load

    @default[:path_to_jsunit].should == "javascripts/jsunit/jsunit"
    config[:path_to_jsunit].should == "javascripts/jsunit"

    @default[:internal_app_server_port].should == 4000
    config[:internal_app_server_port].should == 4000
  end

  it "should override default.yml with host-specific.yml if both exist" do
    Funkytown::FunkytownConfig.should_receive(:load_file).with(Funkytown::FunkytownConfig.machine_specific_filename).and_return({:path_to_jsunit => "myhostisweird"})
    Funkytown::FunkytownConfig.should_receive(:load_file).with(Funkytown::FunkytownConfig.default_filename).and_return({:path_to_jsunit => "javascripts/jsunit"})

    config = Funkytown::FunkytownConfig.load

    config[:path_to_jsunit].should == "myhostisweird"

    @default[:internal_app_server_port].should == 4000
    config[:internal_app_server_port].should == 4000
  end
end

describe "The FunkytownConfig default_config" do
  it "should pick ant correctly based on windows vs unix" do
    SYSTEM.stub!(:windows).and_return(true)
    Funkytown::FunkytownConfig.default_config[:ant].should be_ends_with("lib\\funkytown\\vendor\\ant\\bin\\ant.bat")

    SYSTEM.stub!(:windows).and_return(false)
    Funkytown::FunkytownConfig.default_config[:ant].should be_ends_with("lib/funkytown/vendor/ant/bin/ant")
  end
end

describe "FunkytownConfig's load_file method" do
  it "should load the results of a YAML file into a hash" do
    with_temp_yaml_file("fruit: banana") do |config|
      config[:fruit].should == "banana"
      config[:web_root].should be_nil
    end
  end

  it "should handle empty yaml files" do
    with_temp_yaml_file("") do |config|
      config[:fruit].should be_nil
    end
  end

  it "should handle non-useful yaml files" do
    with_temp_yaml_file("---") do |config|
      config[:fruit].should be_nil
    end
  end

  it "should return an empty hash if the file does not exist" do
    Funkytown::FunkytownConfig.load_file("/missing/file.yml").should == {}
  end

  def with_temp_yaml_file(text, &block)
    tempfile = Tempfile.new("configfile")
    begin
      tempfile.puts(text)
      tempfile.close

      config = Funkytown::FunkytownConfig.load_file(tempfile.path)
      yield(config)
    ensure
      tempfile.delete
    end
  end
end

describe "FunkytownConfig's from_yaml method" do
  it "should read basic YML files fine" do
    config = Funkytown::FunkytownConfig.from_yaml("master_host : 0.1.2.3")
    config[:master_host].should == "0.1.2.3"
    config[:web_root].should be_nil
  end

  it "should read nested YML files fine" do
    data=<<-EOF
selenium_servants:
  localhost:
    - firefox
  supermega:
    - firefox
    - wowie
    EOF
    config = Funkytown::FunkytownConfig.from_yaml(data)
    config[:selenium_servants].should == {
      "localhost" => ["firefox"],
      "supermega" => ["firefox", "wowie"]
    }
  end

  it "should support ERB in YML" do
    config = Funkytown::FunkytownConfig.from_yaml("master_host: <%= '0' + '.' + '1' + '.' + '2' %>")
    config[:master_host].should == "0.1.2"
  end
end

describe "The default FunkytownConfig" do
  it "should return a copy" do
    x = Funkytown::FunkytownConfig.default_config
    real_web_root = x[:web_root]
    x[:web_root] = "foo"
    y = Funkytown::FunkytownConfig.default_config
    y[:web_root].should == real_web_root
    "foo".should_not == y[:web_root]
  end
end