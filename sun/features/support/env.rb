$:.unshift File.join(File.dirname(__FILE__),'..', '..','lib')


require 'rspec-expectations'
#require 'shoulda/matchers'
#
##World(Shoulda::Matchers)
#World do
#  extend Shoulda::Matchers
#end
require 'simplecov'
SimpleCov.adapters.define 'only_lib_code' do
  add_filter 'features'
end
SimpleCov.start 'only_lib_code'

require 'game'
require 'spatial_hash'

def invoke_property_string_on(e, property_string)
  properties = property_string.split(".")
  v = e
  properties.each {|prop|
    v = v.send(prop)
  }
  v
end
$games_by_name = {}

def lookup_game_named(name)
  unless $games_by_name.has_key? name
    $games_by_name[name] = YamlLoader.game_from_file(name)
  end
  $games_by_name[name]
end

Before do |scenario|
  if ENV['do_profile'] =~ /yes/
    require 'ruby-prof'
    RubyProf.start
  end

end

#TODO look into timing each scenario and reporting slow ones that are not already tagged
#TODO consider deferring GC ala rails
After do |scenario|

  if ENV['do_profile'] =~ /yes/
    begin
    result = RubyProf.stop
    ignores = [
      /Cucumber::Runtime#visit_step/,
      /Cucumber::Runtime#step_visited/,
      /Cucumber::Runtime#step_match/,
      /Cucumber::Runtime#after/,
      /Cucumber::Runtime::SupportCode/,
      /Cucumber::Formatter/,
      /Cucumber::Ast/,
      /Cucumber::RbSupport/,
      /Cucumber::LanguageSupport/,
      /Cucumber::StepMatch/,
      /Cucumber::StepDefintion/,
      /Kernel/,
      /String/,
      /Integer/,
      /.*RSpec.*/,
      /.*Mocha.*/,
      /Object/,
      /Symbol/,
      /Module/,
      /Proc/,
      /Fixnum/,
      /Float/,
      /Class/,
      /Mocha/,
      /NilClass/,
      /MatchData/,
      /Array/,
      /Hash/,
      /Enumberable/
    ]
    result.eliminate_methods!(ignores)
    printer = RubyProf::MultiPrinter.new(result)
    n = scenario.respond_to?(:title) ? scenario.title : scenario.name
    t = n.gsub(" ", "_")
    t = n.gsub("|", "_")

    printer.print(:path => "profile", :profile => "#{t}")
    rescue Exception => e
      puts "scenario methods: #{scenario.methods.sort}"
      puts "got error #{e}"
    end
  end


  begin
    #mocha_teardown
    Mocha::Mockery.instance.teardown
    Mocha::Mockery.reset_instance
  rescue Exception => e
    puts "caught exception #{e}"
  end
end