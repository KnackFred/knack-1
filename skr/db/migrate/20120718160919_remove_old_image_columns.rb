class RemoveOldImageColumns < ActiveRecord::Migration

  class ProductImage <ActiveRecord::Base
  end

  def self.up
    remove_column :registrants, :Image_backup
    remove_column :partners, :Image_backup
    remove_column :partners, :LogoImage_backup

    change_table :products do |t|
      t.remove :BigImage_backup
      t.remove :BigImageGUID_backup
      t.remove :MainImage_backup
      t.remove :ImageGUID_backup
      t.remove :IsVertical_backup
    end

    say ("deleting pdf's from product images")
    # There is no way to undo this.
    ProductImage.delete_all("is_pdf = true")

    change_table :product_images do |t|
      t.remove :is_pdf
      t.remove :BigImage_backup
      t.remove :Image_backup
      t.remove :ImageGUID_backup
      t.remove :IsVertical_backup
      t.remove :IsDeleted_backup
    end

  end

  def self.down
    add_column :registrants, :Image_backup, :binary
    add_column :partners, :Image_backup, :binary
    add_column :partners, :LogoImage_backup, :binary

    change_table :products do |t|
      t.binary :BigImage_backup
      t.binary :BigImageGUID_backup
      t.binary :MainImage_backup
      t.string :ImageGUID_backup
      t.boolean :IsVertical_backup
    end

    change_table :product_images do |t|
      t.boolean :is_pdf
      t.binary :BigImage_backup
      t.binary :Image_backup
      t.string :ImageGUID_backup
      t.boolean :IsVertical_backup
      t.boolean :IsDeleted_backup
    end

  end
end
