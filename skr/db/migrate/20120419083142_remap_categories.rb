class RemapCategories < ActiveRecord::Migration
  class Category <ActiveRecord::Base
  end

  class Products2Categories <ActiveRecord::Base
  end

  def self.up
    # NOTE: If you are migrating in test you may to to skpi this one.
    root_id = Category.where(:is_root => true).first.id

    # Delete some categories that are not in use.

    # Move categories out of essentials.
    cat = Category.where(:name => "Kitchen").first
    cat.update_attributes(:parent_id => root_id, :priority => 39)

    # Move categories out of home.
    cat = Category.where(:name => "Dining and Entertaining").first
    cat.update_attributes(:parent_id => root_id, :priority => 38)
    cat = Category.where(:name => "Home Decor").first
    cat.update_attributes(:parent_id => root_id, :priority => 37)
    cat = Category.where(:name => "Bed and Bath").first
    cat.update_attributes(:parent_id => root_id, :priority => 36)

    # Move categories out of Unique Items.
    cat = Category.where(:name => "Furniture").first
    cat.update_attributes(:parent_id => root_id, :priority => 35)
    cat = Category.where(:name => "Art").first
    cat.update_attributes(:parent_id => root_id, :priority => 34)

    # Move Outdoors out of Experiences
    cat = Category.where(:name => "Outdoors").first
    cat.update_attributes(:parent_id => root_id, :priority => 33)

    # Remove the old categories
    cat = Category.where(:name => "Home").first
    # Remove any categorizations of products to home.
    execute "DELETE FROM products2categories WHERE category_id = #{cat.id};"
    # Update and products for which shipping category was set to "HOME".
    execute "UPDATE products SET ShipmentCategory_ID = #{Category.where(:name => "Home Decor").first.id} WHERE ShipmentCategory_ID = #{cat.id};"
    cat.delete

    cat = Category.where(:name => "Essentials").first
    # Remove any categorizations of products to essentials.
    execute "DELETE FROM products2categories WHERE category_id = #{cat.id};"
    cat.delete

    cat = Category.where(:name => "Unique Gifts").first
    # Remove any categorizations of products to essentials.
    execute "DELETE FROM products2categories WHERE category_id = #{cat.id};"
    cat.delete

  end

  def self.down
    root_id = Category.where(:is_root => true).first.id

    #Re-create the deleted categories.
    essentials = Category.create(:is_root => false, :name => "Essentials", :parent_id => root_id, :per_shipment => 7.99, :priority => 50)
    Category.create(:is_root => false, :name => "Home", :parent_id => essentials.id, :per_shipment => 7.99, :priority => 49)
    Category.create(:is_root => false, :name => "Unique Gifts", :parent_id => root_id, :per_shipment => 7.99, :priority => 48)

    # Move categories back into of essentials.
    root_id = Category.where(:name => "Essentials").first.id
    cat = Category.where(:name => "Kitchen").first
    cat.update_attributes(:parent_id => root_id)

    # Move categories back into home.
    root_id = Category.where(:name => "Home").first.id
    cat = Category.where(:name => "Dining and Entertaining").first
    cat.update_attributes(:parent_id => root_id)
    cat = Category.where(:name => "Home Decor").first
    cat.update_attributes(:parent_id => root_id)
    cat = Category.where(:name => "Bed and Bath").first
    cat.update_attributes(:parent_id => root_id)

    # Move categories back into Unique Items.
    root_id = Category.where(:name => "Unique Gifts").first.id
    cat = Category.where(:name => "Furniture").first
    cat.update_attributes(:parent_id => root_id, :priority => 35)
    cat = Category.where(:name => "Art").first
    cat.update_attributes(:parent_id => root_id, :priority => 34)

    # Move Outdoors back under Experiences
    root_id = Category.where(:name => "Experiences").first.id
    cat = Category.where(:name => "Outdoors").first
    cat.update_attributes(:parent_id => root_id, :priority => 33)

  end
end
