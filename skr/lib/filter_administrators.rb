# To change this template, choose Tools | Templates
# and open the template in the editor.

class FilterAdministrators
  attr_accessor :last_name
  attr_accessor :first_name
  attr_accessor :partner
  attr_accessor :id
  attr_accessor :login
  attr_accessor :email

  def initialize
    self.last_name = ''
    self.first_name = ''
    self.partner = ''
    self.id = ''
    self.login = ''
    self.email = ''
  end

  def filter()
    administrators = PartnerAdministrator.all.reverse

    unless self.id.to_s == ''
      administrators = administrators.find_all {|s| s.id.to_s == self.id.to_s}
    end

    unless self.partner == ''
      names = self.partner.split(' ')
      if names.length == 1
        names << names[0]
      end

      administrators = administrators.find_all{ |s|
        if !s.partner.BillingName.blank? && !s.partner.BillingLastName.blank?
        (s.partner.BillingName.upcase.include? names[0].upcase) ||
          (s.partner.BillingName.upcase.include? names[1].upcase) ||
          (s.partner.BillingLastName.upcase.include? names[0].upcase) ||
          (s.partner.BillingLastName.upcase.include? names[1].upcase)
        end
       }
    end

    unless self.first_name == ''
      administrators = administrators.find_all{ |s| s.FirstName.upcase.include? self.first_name.upcase}
    end

    unless self.last_name == ''
      administrators = administrators.find_all{ |s| s.LastName.upcase.include? self.last_name.upcase}
    end

    unless self.login == ''
      administrators = administrators.find_all{ |s| s.Login.upcase.include? self.login.upcase}
    end

    unless self.email == ''
      administrators = administrators.find_all{ |s| s.Email.upcase.include? self.email.upcase}
    end

    administrators
  end
end
