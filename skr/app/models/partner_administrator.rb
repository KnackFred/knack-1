class PartnerAdministrator < ActiveRecord::Base
  belongs_to :partner
  
  validates :first_name,
                          :presence => {:message => "can't be blank"},
                          :length => {:minimum => 0, :maximum => 50}
  validates :last_name,
                          :presence => true,
                          :length => {:minimum => 0, :maximum => 50}
  validates :email,
                          :presence => true,
                          :email_format => true,
                          :length => {:minimum => 0, :maximum => 50},
                          :uniqueness => {:message => "This login is already in use", :case_sensitive => false}
  validates :new_password,
            :presence => {:on => :create},
            :length => {:minimum => 6, :maximum => 20, :on => :create}
  validates_length_of :new_password, :within => 6..20, :on => :update, :if => "change_password == '1'"

  validates :phone,
                          :length => {:minimum => 6, :maximum => 25}, 
                          :phone_format => {:message => "phone must be valid"},
                          :allow_blank => true

  attr_accessor :change_password
  attr_accessor :old_password
  attr_accessor :new_password

  before_update :do_password_change
  before_create :do_password_set

  def self.check_administrator(email, password)
    administrator = PartnerAdministrator.find_by_email_and_is_deleted(email.strip, false)
    if administrator.blank? || !PasswordUtilities.check(password.strip, administrator.password)
      return nil
    end
    administrator
  end

  protected

  def do_password_change
    if self.change_password == "1"
      if (!PasswordUtilities.check((old_password.strip||""), self.password))
        errors.add(:old_password, "Old password incorrect")
        return false
      else
        self.password = PasswordUtilities.hash(self.new_password.strip)
        self.change_password = nil
        self.old_password = nil
        self.new_password = nil
      end
    end
  end

  def do_password_set
    self.password = PasswordUtilities.hash(self.new_password.strip)
  end

end
