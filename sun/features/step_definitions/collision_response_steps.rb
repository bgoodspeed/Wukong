Given /^I create a collision responder$/ do
  @collision_responder = CollisionResponder.new(@game)
  @game.collision_responder = @collision_responder
end

Given /^I create a collision responder from file "([^"]*)"$/ do |file|
  @collision_responder = YamlLoader.from_file(CollisionResponder, @game, "test-data/collision_response/#{file}")
  @game.collision_responder = @collision_responder
end

def mock_collision_type(t)
  m = Mocha::Mock.new("elem")
  m.stubs(:collision_type).returns(t)
  m.stubs(:collision_response_type).returns(t)
  m
end
When /^a collision occurs between type "([^"]*)" and type "([^"]*)"$/ do |type1, type2|
  m1 = mock_collision_type(eval(type1))
  m2 = mock_collision_type(eval(type2))
  col = Collision.new(m1, m2)
  @responses = @collision_responder.response(col)
end


Then /^the collision responses should be:$/ do |table|
  #response_types = @responses
  response_types = @responses.collect{|r| r.to_s}
  table.hashes.each {|hash|
    expected = hash['collision_response_type']

    response_types.should be_include(expected)
  }
end


Then /^the response for "([^"]*)" should enqueue a timed event$/ do |arg1|
  m = Mocha::Mock.new("m1")
  m.stubs(:hud_message).returns "hi"
  m2 = Mocha::Mock.new("m2")
  response = nil
  @collision_responder.responses.each {|k,v|
    if k.to_s == arg1.to_s
      response = v
    end
    }
  response.call(Collision.new(m,m2))
  @game.clock.events.size.should == 1

end

