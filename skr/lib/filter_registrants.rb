# To change this template, choose Tools | Templates
# and open the template in the editor.

class FilterRegistrants
  attr_accessor :id
  attr_accessor :registrant
  attr_accessor :date_from
  attr_accessor :date_to
  attr_accessor :status_id
  attr_accessor :details

  def initialize
    self.id = ''
    self.registrant = ''
    self.status_id = 0
    self.date_from = ''
    self.date_to = ''
    self.details = false
  end

  def filter()
    registrants = Registrant.all.reverse

    unless self.registrant == ''
      names = self.registrant.split(' ')
      if names.length == 1
        names << names[0]
      end

      registrants = registrants.find_all{ |p|
        if !p.FirstName.blank? && !p.LastName.blank?
          (p.FirstName.upcase.include? names[0].upcase) ||
          (p.FirstName.upcase.include? names[1].upcase) ||
          (p.LastName.upcase.include? names[0].upcase) ||
          (p.LastName.upcase.include? names[1].upcase)
        end
       }
    end

    registrants = registrants.find_all{ |p| p.id.to_i == self.id.to_i} unless self.id == ''

    unless self.status_id == 0
      status = self.status_id.to_i == 1 ? false : true
      registrants = registrants.find_all { |p| p.IsDeleted == status  }
    end



    unless self.date_from == ''
      registrants = registrants.find_all{ |p| p.created_at.to_date >= Date.parse(self.date_from) }
    end

    unless self.date_to == ''
      registrants = registrants.find_all{ |p| p.created_at.to_date <= Date.parse(self.date_to) }
    end

    registrants
  end
end
