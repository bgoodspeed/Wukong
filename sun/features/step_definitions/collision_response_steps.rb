Given /^I create a collision responder$/ do
  @collision_responder = CollisionResponder.new(@game)
  @game.collision_responder = @collision_responder
end


def mock_collision_type(t)
  m = Mocha::Mock.new("elem")
  m.stubs(:collision_type).returns(t)
  m
end
When /^a dynamic collision occurs between type "([^"]*)" and type "([^"]*)"$/ do |type1, type2|
  m1 = mock_collision_type(eval(type1))
  m2 = mock_collision_type(eval(type2))
  col = DynamicCollision.new(m1, m2)
  @responses = @collision_responder.dynamic_response(col)
end

When /^a static collision occurs between type "([^"]*)" and type "([^"]*)"$/ do |type1, type2|
  m1 = mock_collision_type(eval(type1))
  m2 = mock_collision_type(eval(type2))
  #TODO get rid of static vs dynamic collisions, should only be one.
  col = StaticCollision.new(m2, m1)
  @responses = @collision_responder.static_response(col)
end

Then /^the dynamic collision responses should be:$/ do |table|
  #response_types = @responses
  response_types = @responses.collect{|r| r.to_s}
  table.hashes.each {|hash|
    expected = hash['collision_response_type']

    response_types.should be_include(expected)
  }
end

Then /^the static collision responses should be:$/ do |table|
  #response_types = @responses
  response_types = @responses.collect{|r| r.to_s}
  table.hashes.each {|hash|
    expected = hash['collision_response_type']

    response_types.should be_include(expected), "***expected:#{response_types} to contain #{expected}***"
  }
end