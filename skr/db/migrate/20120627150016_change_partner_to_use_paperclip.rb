class ChangePartnerToUsePaperclip < ActiveRecord::Migration

  class Partner <ActiveRecord::Base
    has_attached_file :logo,
                      :styles => {:small => ["169x127", :png],
                                  :medium => ["193x145", :png],
                                  :for_crop => ["400x300", :png]},
                      :convert_options => {:small => "-gravity center -extent 168x126 -strip -quality 7",
                                           :medium => "-gravity center -extent 192x144 -strip -quality 7",
                                           :for_crop => "-gravity center -strip -quality 7"}
  end

  def self.up
    change_table :partners do |t|
      t.has_attached_file :logo
    end

    say ("converting images")
    Partner.all.each do |partner|
      begin
        if partner.LogoImage.blank?
          say ("using default image for partner #{partner.id}")
          file = File.new("#{Rails.root}/public/images/defaultImage.png")
        else
          say ("converting image for partner #{partner.id}")
          file = StringIO.new(partner.LogoImage)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = partner.LogoGUID
          file.content_type = 'image/jpeg'
        end
        partner.logo = file
        partner.save!()
      rescue Exception => exc
        say ("exception for partner #{partner.id}")
        say (exc)
      end
    end
  end

  def self.down
    drop_attached_file :partners, :logo
  end
end
