class RenameOldImageColumns < ActiveRecord::Migration
  def self.up
    rename_column :registrants, :Image, :Image_backup
    rename_column :partners, :Image, :Image_backup
    rename_column :partners, :LogoImage, :LogoImage_backup
  end

  def self.down
    rename_column :registrants, :Image_backup, :Image
    rename_column :partners, :Image_backup, :Image
    rename_column :partners, :LogoImage_backup, :LogoImage
  end
end
