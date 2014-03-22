class ChangeRegistrantToUsePaperclip < ActiveRecord::Migration

  class Registrant <ActiveRecord::Base
    has_attached_file :profile_image,
                      :styles => {:small => ["121x91", :png],
                                  :medium => ["191x144", :png],
                                  :large => ["249x187", :png],
                                  :for_crop => ["400x300", :png]},
                      :convert_options => {:small => "-gravity center -extent 120x90 -strip -quality 7",
                                           :medium => "-gravity center -extent 190x143 -strip -quality 7",
                                           :large => "-gravity center -extent 248x186 -strip -quality 7",
                                           :for_crop => "-gravity center -strip -quality 7"}
  end

  def self.up
    change_table :registrants do |t|
      t.has_attached_file :profile_image
    end

    say ("converting images")
    Registrant.all.each do |reg|
      begin
        if reg.Image && reg.ImageGUID
          say ("converting image for registrant #{reg.id}")
          file = StringIO.new(reg.Image)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = reg.ImageGUID
          file.content_type = 'image/jpeg'
          reg.profile_image = file
          reg.save!()
        else
          say ("skipping image for registrant #{reg.id}")
        end
      rescue Exception => exc
        say ("exception for registrant #reg.id}")
        say (exc)
      end
    end
  end

  def self.down
    drop_attached_file :registrants, :profile_image
  end
end
