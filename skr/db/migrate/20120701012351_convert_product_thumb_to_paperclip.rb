class ConvertProductThumbToPaperclip < ActiveRecord::Migration

  class Product <ActiveRecord::Base
    has_attached_file :main_product_thumb,
                      :styles => {:small => ["105x79", :jpg],
                                  :medium => ["161x121", :jpg],
                                  :for_crop => ["400x300", :jpg]},
                      :convert_options => {:small => "-gravity center -extent 104x78 -strip -quality 80",
                                           :medium => "-gravity center -extent 160x120 -strip -quality 80",
                                           :for_crop => "-gravity center -strip -quality 80"}

    has_attached_file :main_product_image,
                      :styles => {:small => ["52x52^", :jpg],
                                  :large => ["370", :jpg]},
                      :convert_options => {:small => "-gravity center -extent 52x52 -strip -quality 80",
                                           :large => "-strip -quality 80"}
  end

  def self.up
    change_table :products do |t|
      t.has_attached_file :main_product_thumb
      t.has_attached_file :main_product_image
    end


    say ("converting images")
    Product.all.each do |product|
      begin
        if product.MainImage.blank?
          say ("using default image for thumbnail of product #{product.id}")
          file = File.new("#{Rails.root}/public/images/defaultImage.png")
        else
          say ("converting image for thumbnail of product #{product.id}")
          file = StringIO.new(product.MainImage)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = product.ImageGUID
          file.content_type = 'image/jpeg'
        end
        product.main_product_thumb = file
        product.save!()
      rescue Exception => exc
        say ("exception for thumbnail of product #{product.id}")
        say (exc)
      end

      begin
        if product.BigImage
          say ("converting big image for main image for product #{product.id}")
          file = StringIO.new(product.BigImage)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = product.BigImageGUID
          file.content_type = 'image/jpeg'
        elsif product.MainImage
          say ("converting main image for main image for product #{product.id}")
          file = StringIO.new(product.MainImage)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = product.ImageGUID
          file.content_type = 'image/jpeg'
        else
          say ("using default image for main image for product #{product.id}")
          file = File.new("#{Rails.root}/public/images/defaultImage.png")
        end
        product.main_product_image = file
        product.save!()
      rescue Exception => exc
        say ("exception for product #{product.id}")
        say (exc)
      end
    end

    #Remove some constraints
    execute "alter table products change ImageGUID ImageGUID char(39);"

    change_table :products do |t|
      t.rename :BigImage, :BigImage_backup
      t.rename :BigImageGUID, :BigImageGUID_backup
      t.rename :MainImage, :MainImage_backup
      t.rename :ImageGUID, :ImageGUID_backup
      t.rename :IsVertical, :IsVertical_backup
    end

  end

  def self.down
    drop_attached_file :products, :main_product_thumb
    drop_attached_file :products, :main_product_image

    change_table :products do |t|
      t.rename :BigImage_backup, :BigImage
      t.rename :BigImageGUID_backup, :BigImageGUID
      t.rename :MainImage_backup, :MainImage
      t.rename :ImageGUID_backup, :ImageGUID
      t.rename :IsVertical_backup, :IsVertical
    end
  end

end
