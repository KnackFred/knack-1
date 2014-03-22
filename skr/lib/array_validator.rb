class ArrayValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value.kind_of?(Array)
      object.errors[attribute] << (options[:message] || 'Not array.')
      return
    end
    
    unless options[:type].blank?
      value.each do |v|
        unless v.kind_of?(options[:type])
          object.errors[attribute] << (options[:message] || 'Element in array not valid type.')
          return
        end
      end
    end
  end
end