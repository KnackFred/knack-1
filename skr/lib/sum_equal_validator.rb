class SumEqualValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    first_operand = options[:first_operand].to_f
    second_operand = options[:second_operand].to_f
    unless value == first_operand + second_operand
      object.errors[attribute] << (options[:message] || 'Sum not equal.')
    end
  end
end