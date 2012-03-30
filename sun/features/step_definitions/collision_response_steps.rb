Given /^I create a collision responder$/ do
  @collision_responder = CollisionResponder.new(@game)
  @game.collision_responder = @collision_responder
end

Given /^I create a collision responder from file "([^"]*)"$/ do |file|
  @collision_responder = CollisionResponder.from_file(@game, "test-data/collision_response/#{file}")
  @game.collision_responder = @collision_responder
end

def mock_collision_type(t)
  m = Mocha::Mock.new("elem")
  m.stubs(:collision_type).returns(t)
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
