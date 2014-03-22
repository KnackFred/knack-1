class ZipFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /(^\d{5}$)|(^\d{5}-\d{4}$)/
      object.errors[attribute] << (options[:message] || 'You must provide a valid ZIP.')
    end
  end
end