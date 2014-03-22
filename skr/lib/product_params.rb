class ProductParams
  attr_accessor :list
  def initialize(params, type)
    self.list = Array.new

    params.each do |p|
      self.list << ParamProduct.new(p, type)
    end
  end

  def valid?
    if self.list.blank?
      return true
    else
      self.list.each do |l|
        unless l.valid_param?
          return false
        end
      end
      return true
    end
  end

  def delete_params(params)
    params.each do |p|
      if (self.list.find_all { |l| l.id.to_s == p.id.to_s}).length == 0
        p.delete_values
        ProductParam.delete(p.id)
      end
    end
  end
end

class ParamProduct
  attr_accessor :id
  attr_accessor :name
  attr_accessor :values
  attr_accessor :is_template

  def initialize(param, type)
    case type.to_i
    when 1
      self.id = param["id"]
      self.name = param["name"]
      self.values = param["values"]
      self.is_template = param["template"]
    when 2
      self.id = param.id
      self.name = param.Name
      self.is_template = param.IsTemplate
      self.values = ''

      param.value_params.each do |v|
        self.values += v.Value.to_s + ','
      end


      if param.value_params.length > 0
        self.values[self.values.length - 1] = ''
      end
    end

    
  end

  def list_values
    return self.values.gsub("undefined,", "").split(',').find_all {|l| !l.blank?}
  end

  def valid_param?
    if self.name.blank?
      return false
    end

    if self.values.blank?
      return false
    end

    return true
  end
end

class ParamTemplate
  attr_accessor :id
  attr_accessor :name
  attr_accessor :values
  attr_accessor :product_id
  attr_accessor :partner_id

  def initialize(param)
      self.id = param["id"]
      self.name = param["name"]
      self.values = param["values"]
      self.product_id = param["product_id"]
      self.partner_id = param["partner_id"]
  end

  def list_values
    return self.values.gsub("undefined,", "").split(',').find_all {|l| !l.blank?}
  end

  def valid_param?
    if self.name.blank?
      return false
    end

    if self.values.blank?
      return false
    end

    if self.product_id.blank?
      return false
    end

    if self.partner_id.blank?
      return false
    end

    return true
  end
end