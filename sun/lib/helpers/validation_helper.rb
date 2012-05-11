module ValidationHelper
  module Validation
    VALID = :valid
    def self.invalid(unset)
      "Need to set #{unset}"
    end
  end

  def valid?(attributes=required_attributes)
    unset = attributes.select {|attr| self.send(attr).nil?}
    return Validation::VALID if unset.empty?

    Validation.invalid(unset)
  end

  def validation_error(user_msg, atts=[])
    msg =  ("*" * 80) + "\n From file #{@which_level}\n#{user_msg}, required are: #{atts}"
    @game.log.fatal msg
    puts msg
  end
  def check_validation_error(obj, user_msg, atts=[])
    v = obj.valid?
    return if v == ValidationHelper::Validation::VALID
    validation_error("#{user_msg}: these were unset: [#{v}]", atts)
  end

end