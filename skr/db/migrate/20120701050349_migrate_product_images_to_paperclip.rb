require 'pdf/reader'
class MigrateProductImagesToPaperclip < ActiveRecord::Migration
  class ProductImage <ActiveRecord::Base
    has_attached_file :product_image,
                      :styles => {:small => ["52x52^", :jpg],
                                  :large => ["370", :jpg]},
                      :convert_options => { :small => "-gravity center -extent 52x52 -strip -quality 80",
                                            :large => "-strip -quality 80"}
  end

  class ProductAttachment <ActiveRecord::Base
    has_attached_file :product_attachment
  end

  class Product <ActiveRecord::Base
  end

  def self.up

    #Create the product attachments table
    create_table :product_attachments do |t|
      t.string :title, :limit => 100
      t.references :product
      t.has_attached_file :product_attachment
      t.timestamps
    end

    # Change the product images table to match convention.
    rename_table :productimages, :product_images

    change_table :product_images do |t|
      t.rename :Product_ID, :product_id
      t.rename :IsPDF, :is_pdf

      t.has_attached_file :product_image
    end

    say ("converting product images")
    ProductImage.all.each do |product_image|
      begin
        if product_image.is_pdf?
          say ("converting pdf for product image #{product_image.id}")
          file = StringIO.new(product_image.Image)
          file.class.class_eval { attr_accessor :original_filename, :content_type }
          file.original_filename = product_image.ImageGUID
          file.content_type = 'application/pdf'

          write_file(product_image.ImageGUID, product_image.ImageGUID, '.png')
          title = read_pdf_title(product_image.ImageGUID)
          if title == ""
            say ("pdf title blank")
            title = "pdf"
          end

          atch = ProductAttachment.new
          atch.title = title
          atch.product_attachment = file
          atch.product_id = product_image.product_id
          atch.save!()
        else
          if product_image.BigImage
            say ("converting big image for product image #{product_image.id}")
            file = StringIO.new(product_image.BigImage)
            file.class.class_eval { attr_accessor :original_filename, :content_type }
            file.original_filename = product_image.ImageGUID
            file.content_type = 'image/jpeg'
          elsif product_image.Image
            say ("converting image for product image #{product_image.id}")
            file = StringIO.new(product_image.Image)
            file.class.class_eval { attr_accessor :original_filename, :content_type }
            file.original_filename = product_image.ImageGUID
            file.content_type = 'image/jpeg'
          else
            say ("using default image for product image #{product_image.id}")
            file = File.new("#{Rails.root}/public/images/defaultImage.png")
          end
          product_image.product_image = file
          product_image.save!()
        end
      rescue Exception => exc
        say ("exception for product #{product_image.id}")
        say (exc.to_s)
      end
    end

    # rename columns that we will delete eventually to backup
    change_table :product_images do |t|

      t.rename :BigImage, :BigImage_backup
      t.rename :Image, :Image_backup
      t.rename :ImageGUID, :ImageGUID_backup
      t.rename :IsVertical, :IsVertical_backup
      t.rename :IsDeleted, :IsDeleted_backup
    end

    #Remove some constraints
    execute "alter table product_images change ImageGUID_backup ImageGUID_backup char(39);"
    #Set a default status for new products,
    execute "alter table products alter column ProductStatus_ID SET DEFAULT 3;"
  end

  def self.down

    drop_table :product_attachments

    drop_attached_file :product_images, :product_image
    rename_table :product_images, :productimages


    change_table :productimages do |t|

      t.rename :is_pdf, :IsPDF
      t.rename :product_id, :Product_ID

      t.rename :BigImage_backup, :BigImage
      t.rename :Image_backup, :Image
      t.rename :ImageGUID_backup, :ImageGUID
      t.rename :IsVertical_backup, :IsVertical
      t.rename :IsDeleted_backup, :IsDeleted

    end

  end

  class MetaDataReceiver
    attr_accessor :regular
    attr_accessor :xml

    def metadata(data)
      @regular = data
    end

    def metadata_xml(data)
      @xml = data
    end
  end

  def self.read_pdf_title(uuid)
    begin
      directory = "#{Rails.root}/public/images/upload/"

      name = "#{uuid}.pdf"
      path =  File.join(directory, name)

      if File.exist?(path)
        receiver = MetaDataReceiver.new
        pdf = PDF::Reader.file(path, receiver, :pages => false, :metadata => true)
        return receiver.regular[:Title]
      end
    rescue Exception => e
      return ""
    end

    return ""
  end

  def self.write_file(uuid, data, extension = '.jpg', directory = "#{Rails.root}/public/images/upload/")
    begin
      name = uuid + extension
      path =  File.join(directory, name)
      f = File.open(path, 'wb')

      if data.blank? || data.length == 0
        data = ImageUtilities.get_default_image
      end

      f.write(data)
      f.close
    rescue
    end
  end

end
