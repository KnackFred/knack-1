require "rubygems"
require "RMagick"
require 'open-uri'
require 'net/http'
require 'pdf/reader'
require 'base64'

Rails.root = "#{File.dirname(__FILE__)}/.." unless defined?(Rails.root)

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

module ImageUtilities
############## read #######################################
  def self.read_file(uuid, extension = '.jpg', directory = "#{Rails.root}/public/images/upload/")
    begin
      name = uuid + extension
      path =  File.join(directory, name)

      data = ''
      if File.exist?(path)
        f = File.open(path, 'rb')
        data = f.read
        f.close
      end

      data
    rescue
      ''
    end
  end

  def self.read_image(uuid)
    read_file(uuid, '.jpg')
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

  def self.read_big_image(uuid)
    read_file(uuid, '_b.jpg')
  end

  def self.read_pdf(uuid)
    read_file(uuid, '.pdf')
  end

  def self.get_default_image
    read_file("defaultImage", ".png", "#{Rails.root}/public/images/")
  end

  def self.get_default__profile_image
    read_file("defaultProfileImage", ".png", "#{Rails.root}/public/images/")
  end

  def self.get_pdf_image
    read_file("pdf", ".jpg", "#{Rails.root}/public/images/")
  end

  def self.get_logo_image
    read_file("/design/logo", ".gif", "#{Rails.root}/public/images/")
  end

############## delete #######################################
  def self.delete_file(uuid, extension = ".jpg")
    directory = "#{Rails.root}/public/images/upload/"

    name = uuid
    path =  File.join(directory, name)

    data = ''
    if File.exist?(path)
      File.delete(path)
    end
  end

  def self.delete_image(uuid)
    delete_file(uuid, ".jpg")
  end

############## write #######################################
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

  def self.write_image(uuid, data)
    write_file(uuid, data, ".jpg")
  end

  def self.write_big_image(uuid, data)
    write_file(uuid, data, "_b.jpg")
  end

  def self.write_pdf(uuid, data)
    write_file(uuid, data, ".pdf")
  end

############# resize #######################################
  def self.get_percent_scale(width, height, width_block, height_block)
    percent_w = 1
    percent_h = 1

    if width >= width_block
     percent_w = width_block.to_f / width.to_f
    end

    if height >= height_block
     percent_h = height_block.to_f / height.to_f
    end

    if percent_w > percent_h
     percent = percent_h
    else
     percent = percent_w
    end

    if percent > 1 || percent <= 0
     percent = 1
    end

    percent
  end

  def self.resize(uuid, width_block, height_block, extension = ".jpg", directory = "#{Rails.root}/public/images/upload/")
    begin
       name = uuid + extension
       path =  File.join(directory, name)

       if File.exist?(path)
         img =  Magick::Image.read(path).first
         percent = get_percent_scale(img.columns, img.rows, width_block, height_block)

         thumb = img.scale(percent)
         thumb.write(path)

         width = thumb.columns
         height = thumb.rows

         img.destroy! unless img.blank?
         thumb.destroy! unless thumb.blank?

         return "#{width},#{height}"
       end
    rescue
      img.destroy! unless img.blank?
      thumb.destroy! unless thumb.blank?
      return nil
    end
  end

  def self.resize_big(uuid, width_block, height_block)
    resize(uuid, width_block, height_block, "_b.jpg")
  end

  def self.resize_online(data, width_block, height_block)
    begin
      unless data.blank?
        img =  Magick::Image.read_inline(Base64.b64encode(data)).first

        percent = get_percent_scale(img.columns, img.rows, width_block, height_block)

        thumb = img.scale(percent).to_blob
      else
        nil
      end
    rescue
      nil
    end
  end

############# crop #########################################
  def self.crop(uuid, x, y, width, height, add_id = nil)
    begin
       directory = "#{Rails.root}/public/images/upload/"

       name = uuid + '.jpg'
       path =  File.join(directory, name)

       unless add_id.blank?
         add_name = add_id + '.jpg'
         add_path =  File.join(directory, add_name)
       end
       data = ''
       if File.exist?(path)
         img =  Magick::Image.read(path).first

         thumb = img.crop(x, y, width, height)

         if add_path.blank?
           thumb.write(path)
         else
           thumb.write(add_path)
         end

         img.destroy! unless img.blank?
         thumb.destroy! unless thumb.blank?

         return true
       end
       return false
    rescue
      img.destroy! unless img.blank?
      thumb.destroy! unless thumb.blank?
      return false
    end
  end

############# information ##################################
  def self.is_image?(content_type)
    case content_type
      when "image/gif"
        return true
      when "image/png"
        return true
      when "image/jpg"
        return true
      when "image/jpeg"
        return true
      when "image/pjpeg"
        return true
      else
        return false
    end
  end

  def self.is_pdf?(content_type)
    case content_type
      when "application/pdf"
        return true
      else
        return false
    end
  end

  def self.is_allowable_file_size?(fileSize)
    if fileSize.to_i > 3145728
      return false
    else
      return true
    end
  end

  def self.get_size(uuid, extension = ".jpg")
    begin
      directory = "#{Rails.root}/public/images/upload/"

      name = uuid + extension
      path =  File.join(directory, name)

      if File.exist?(path)
        img =  Magick::Image.read(path).first
        width = img.columns
        height = img.rows
        img.destroy! unless img.blank?

        return "#{width},#{height}"
      end
    rescue
      img.destroy! unless img.blank?
      return nil
    end
  end

  def self.get_size_big(uuid)
    get_size(uuid, "_b.jpg")
  end

  def self.get_guid(options={})
    uuid = UUIDTools::UUID.random_create
    uuid.to_s.tr('{}-','').gsub(' ', '')
  end

  def self.get_image_by_url(url)
    if url then
      begin
        url = URI.parse(url)
        return open(url)
      rescue
      end
    end
    nil
  end


  def self.save_uploaded_file(file, guid, big_guid)
    unless file.blank?
      if file.size > 0
        data = file.read
        if ImageUtilities.is_allowable_file_size?(data.length)
          if ImageUtilities.is_image?(file.content_type)
            ImageUtilities.write_image(guid, data)

            big_guid += "_b" if guid == big_guid
            ImageUtilities.write_image(big_guid, data)

            size = ImageUtilities.resize(guid, 800, 470)

            return "200,#{size}"
          else
            if ImageUtilities.is_pdf?(file.content_type)
              ImageUtilities.write_image(guid, ImageUtilities.get_pdf_image)
              ImageUtilities.write_pdf(guid, data)
              return 100
            else
              return 1
            end
          end
        else
          return 1
        end
      end
    end

    ImageUtilities.write_image(guid, ImageUtilities.get_default_image)
    ImageUtilities.write_image(big_guid, ImageUtilities.get_default_image)
    return 300
  end

end
