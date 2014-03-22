class ProductImage < ActiveRecord::Base
  belongs_to :product
  has_attached_file :product_image,
                    :styles => {:small => ["52x52^", :jpg],
                                :large => ["370", :jpg]},
                    :convert_options => { :small => "-gravity center -extent 52x52 -strip -quality 80",
                                          :large => "-strip -quality 80"}

  validates_attachment_presence :product_image
  validates_attachment_content_type :product_image, :content_type => %w(image/jpg image/jpeg image/png)
  validates_attachment_size :product_image, { :in => 0..3.megabytes }

end
