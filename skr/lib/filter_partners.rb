# To change this template, choose Tools | Templates
# and open the template in the editor.

class FilterPartners
  attr_accessor :id
  attr_accessor :partner
  attr_accessor :date_from
  attr_accessor :date_to
  attr_accessor :status_id

  def initialize
    self.id = ''
    self.partner = ''
    self.status_id = 0
    self.date_from = ''
    self.date_to = ''
  end

  def filter()
    partners = Partner.all.reverse

    unless self.partner.blank?
      names = self.partner.split(' ')
      if names.length == 1
        names << names[0]
      end

      partners = partners.find_all{ |p|
        if !p.BillingName.blank? && !p.BillingLastName.blank?
        (p.BillingName.upcase.include? names[0].upcase) ||
          (p.BillingName.upcase.include? names[1].upcase) ||
          (p.BillingLastName.upcase.include? names[0].upcase) ||
          (p.BillingLastName.upcase.include? names[1].upcase)
        end
       }
    end

    partners = partners.find_all{ |p| p.id.to_i == self.id.to_i} unless self.id.blank?

    unless self.status_id == 0
      status = self.status_id.to_i == 1 ? false : true
      partners = partners.find_all { |p| p.IsDeleted == status  }
    end



    unless self.date_from.blank?
      partners = partners.find_all{ |p| p.created_at.to_date >= Date.parse(self.date_from) }
    end

    unless self.date_to.blank?
      partners = partners.find_all{ |p| p.created_at.to_date <= Date.parse(self.date_to) }
    end

    partners
  end
end
