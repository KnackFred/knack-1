class PhoneFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /\A\S[0-9\+\/\(\)\s\-]*\z/i
      object.errors[attribute] << (options[:message] || 'You must provide a valid Phone number.')
    end
  end
end