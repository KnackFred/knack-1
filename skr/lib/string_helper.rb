# To change this template, choose Tools | Templates
# and open the template in the editor.

class StringHelper
  def initialize
    
  end

  def self.string_to_html(string)
    Sanitize.clean(string.gsub("\n", "<br/>").gsub("\r", ""), Sanitize::Config::BASIC).html_safe unless string.nil?
  end
end
