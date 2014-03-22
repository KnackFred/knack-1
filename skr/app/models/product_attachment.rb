class ProductAttachment < ActiveRecord::Base

  belongs_to :product

  has_attached_file :product_attachment

  ICON_URL = "/images/pdf.jpg"

  validates     :title,
                :presence => true,
                :length => {
                    :minimum => 0,
                    :maximum => 100,
                    :message => "title is too long (maximum is 50 characters)"
                }

  validates_attachment_presence :product_attachment
  validates_attachment_size :product_attachment, { :in => 0..5.megabytes }

end
