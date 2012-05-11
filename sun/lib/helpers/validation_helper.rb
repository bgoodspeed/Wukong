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
end