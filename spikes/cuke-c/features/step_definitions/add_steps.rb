
Given /^I visit the calculator page$/ do
  @data = {}
end

Given /^I fill in '(.*)' for '(.*)'$/ do |value, field|
  @data[field] = value.to_i
end

def process(d)
  if @data[:operation] =~ /Add/
    @data['first'] + @data['second']
  end
end

When /^I press '(.*)'$/ do |name|
  @data[:operation] = name

  @result = process(@data)
end

Then /^I should see '(.*)'$/ do |text|
  @result == text.to_i
end