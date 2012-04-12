When /^I start profiling$/ do
  require 'ruby-prof'
  RubyProf.start
end

When /^I stop profiling reporting to "([^"]*)"$/ do |s|
  result = RubyProf.stop
  ignores = [
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
    /Hash/,
  ]
  result.eliminate_methods!(ignores)
  printer = RubyProf::MultiPrinter.new(result)

  Dir.mkdir "profile" unless File.exists?("profile")
  printer.print(:path => "profile", :profile => s)

end
