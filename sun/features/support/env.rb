$:.unshift File.join(File.dirname(__FILE__),'..', '..','lib')


require 'rspec-expectations'
#require 'shoulda/matchers'
#
##World(Shoulda::Matchers)
#World do
#  extend Shoulda::Matchers
#end

require 'game'
require 'spatial_hash'
#module CustomGameMatchers
#class ScreenshotMatcher
#  def initialize(expected)
#    @expected = expected
#  end
#
#  def matches?(target)
#    @target = target
#    raise "not done yet"
#  end
#  def failure_message
#    "expected #{@expected} to match #{@target}"
#  end
#end
#
#def match_goldmaster(expected)
#  ScreenshotMatcher.new(expected)
#end
#end
#
#module CukeWorld
#  include CustomGameMatchers
#  extend CustomGameMatchers
#end
#World(CukeWorld)
#Spec::Runner.configure do |config|
#  config.include(CustomGameMatchers)
#end

After do |scenario|
  # Do something after each scenario.
  # The +scenario+ argument is optional, but
  # if you use it, you can inspect status with
  # the #failed?, #passed? and #exception methods.

#  if(scenario.failed?)
#    subject = "[Project X] #{scenario.exception.message}"
#    send_failure_email(subject)
#  end
  begin
    #mocha_teardown
    Mocha::Mockery.instance.teardown
    Mocha::Mockery.reset_instance
  rescue Exception => e
    puts "caught exception #{e}"
  end
end