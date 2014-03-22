class DateFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    begin
      date = Date.parse(value.to_s)
      r = true
    rescue Exception => e   
      r = false
    end
    object.errors[attribute] << (options[:message] || "You must provide a valid date.") unless r
    # unless value =~ /(^\d{2}\/\d{2}\/\d{4}$)/
    #       object.errors[attribute] << (options[:message] || 'Date must be valid')
    #     end
  end
end