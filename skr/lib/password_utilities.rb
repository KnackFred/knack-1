# To change this template, choose Tools | Templates
# and open the template in the editor.
require "digest"

class PasswordUtilities
  def initialize
    
  end

  def self.generate_new
    return ImageUtilities.get_guid().first(10)
  end

  def self.hash(password)
    return Digest::MD5.hexdigest(password)
  end

  def self.check(password, encrypted)
    encrypted_str = self.hash(password)

    if (encrypted.to_s == encrypted_str.to_s)
      return true
    else
      return false
    end
  end
end
