# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140219081315) do

  create_table "brands", :force => true do |t|
    t.string   "Name",       :limit => 50, :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                :default => false, :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name",         :limit => 50,                                :default => "",    :null => false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "per_shipment",               :precision => 10, :scale => 2,                    :null => false
    t.boolean  "is_root",                                                   :default => false, :null => false
    t.integer  "priority"
    t.boolean  "visible",                                                   :default => false
  end

  create_table "closed_payment_statuses", :force => true do |t|
    t.boolean  "IsDeleted",                :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "Name",       :limit => 20,                    :null => false
  end

  create_table "closed_payments", :force => true do |t|
    t.boolean  "IsDeleted",                                     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id",                                                         :null => false
    t.integer  "typepayment_id",                                                   :null => false
    t.decimal  "amount",         :precision => 11, :scale => 2, :default => 0.0,   :null => false
    t.integer  "status_id",                                     :default => 1,     :null => false
  end

  add_index "closed_payments", ["order_id"], :name => "orders_closed_payments_fk"
  add_index "closed_payments", ["status_id"], :name => "statuses_closed_payments_fk"
  add_index "closed_payments", ["typepayment_id"], :name => "typepayments_closed_payments_fk"

  create_table "colors", :force => true do |t|
    t.string   "Name",       :limit => 50, :default => "",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                :default => false,    :null => false
    t.string   "RGB",        :limit => 6,  :default => "ffffff"
  end

  create_table "commissions", :force => true do |t|
    t.string   "Name",       :limit => 30,                    :null => false
    t.float    "Percent",                                     :null => false
    t.boolean  "IsDeleted",                :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commissions", ["id"], :name => "id", :unique => true

  create_table "contributes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "Contribute",                      :precision => 11, :scale => 2,                    :null => false
    t.string   "Notes",            :limit => 300,                                :default => ""
    t.integer  "registry_item_id",                                                                  :null => false
    t.string   "From",             :limit => 50
    t.boolean  "external",                                                       :default => false
  end

  add_index "contributes", ["registry_item_id"], :name => "r2p_contributes_fk"

  create_table "email_servers", :force => true do |t|
    t.string  "address",   :limit => 50
    t.integer "port"
    t.boolean "tls"
    t.string  "user_name", :limit => 50
    t.string  "password",  :limit => 50
    t.string  "domain",    :limit => 50
    t.string  "from",      :limit => 50
  end

  create_table "follows", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "registrant_id"
    t.integer  "followed_id"
  end

  add_index "follows", ["followed_id"], :name => "followed_registrant_fk"
  add_index "follows", ["registrant_id"], :name => "follows_registrant_fk"

  create_table "knack_payments", :force => true do |t|
    t.integer  "Order2Product_ID"
    t.integer  "order2registry_item_id"
    t.integer  "Partner_ID"
    t.decimal  "Amount",                 :precision => 11, :scale => 2
    t.boolean  "IsDeleted",                                             :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "DateTime"
    t.integer  "Withdrawal_ID"
  end

  add_index "knack_payments", ["Order2Product_ID"], :name => "o2p_knack_payment_fk"
  add_index "knack_payments", ["Partner_ID"], :name => "partner_knack_payment_fk"
  add_index "knack_payments", ["Withdrawal_ID"], :name => "withdrawal_knack_payments_fk"
  add_index "knack_payments", ["order2registry_item_id"], :name => "o2r2p_knack_payments_fk"

  create_table "line_statuses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                :default => false, :null => false
    t.string   "name",       :limit => 20,                    :null => false
    t.string   "alias",      :limit => 10,                    :null => false
  end

  create_table "order2payments", :force => true do |t|
    t.integer  "Order_ID",                      :null => false
    t.integer  "Payment_ID",                    :null => false
    t.boolean  "IsDeleted",  :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order2payments", ["Order_ID"], :name => "orders_order2payments_fk"
  add_index "order2payments", ["Payment_ID"], :name => "payment_order2payments_fk"

  create_table "order_line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "registry_item_id"
    t.integer  "quantity"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from"
    t.string   "notes"
  end

  add_index "order_line_items", ["order_id"], :name => "index_order_line_items_on_order_id"
  add_index "order_line_items", ["registry_item_id"], :name => "index_order_line_items_on_registry_item_id"

  create_table "order_lines", :force => true do |t|
    t.integer "Store_ID",     :null => false
    t.integer "Order_ID",     :null => false
    t.integer "Product_ID"
    t.integer "MyProduct_ID"
    t.integer "Value",        :null => false
  end

  add_index "order_lines", ["MyProduct_ID"], :name => "order_lines_fk"
  add_index "order_lines", ["Order_ID"], :name => "orders_order_lines_fk"
  add_index "order_lines", ["Product_ID"], :name => "products_order_lines_fk"
  add_index "order_lines", ["Store_ID"], :name => "stores_order_lines_fk"

  create_table "orders", :force => true do |t|
    t.integer  "registrant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["registrant_id"], :name => "registrant_orders_fk"

  create_table "orders_statuses", :force => true do |t|
    t.string   "Name",       :limit => 20, :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                :default => false, :null => false
  end

  create_table "partner_administrators", :force => true do |t|
    t.boolean  "is_deleted",               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name", :limit => 50,                    :null => false
    t.string   "last_name",  :limit => 50,                    :null => false
    t.string   "password",   :limit => 50,                    :null => false
    t.string   "phone",      :limit => 50
    t.string   "email",      :limit => 50
    t.integer  "partner_id",                                  :null => false
  end

  add_index "partner_administrators", ["partner_id"], :name => "partners_partner_administrators_fk"

  create_table "partners", :force => true do |t|
    t.string   "Email",               :limit => 30,                                                    :null => false
    t.string   "Password",            :limit => 50,                                                    :null => false
    t.string   "FirstName",           :limit => 30
    t.string   "LastName",            :limit => 30
    t.string   "Address",             :limit => 50
    t.boolean  "AgreeWithSitePolicy",                                               :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                                                         :default => false, :null => false
    t.string   "ZIP",                 :limit => 10
    t.integer  "PhoneNumber"
    t.string   "Description",         :limit => 900
    t.string   "City",                :limit => 50
    t.integer  "State_ID"
    t.string   "ImageGUID",           :limit => 40
    t.decimal  "Cash",                               :precision => 11, :scale => 0, :default => 0,     :null => false
    t.integer  "PaymentSystem"
    t.string   "OwnerName",           :limit => 50
    t.string   "OwnerLastName",       :limit => 50
    t.string   "OwnerStreet",         :limit => 50
    t.string   "OwnerCity",           :limit => 50
    t.string   "OwnerZIP",            :limit => 10
    t.string   "OwnerPhone",          :limit => 50
    t.string   "OwnerEmail",          :limit => 50
    t.integer  "OwnerState_ID"
    t.string   "BillingName",         :limit => 50
    t.string   "BillingLastName",     :limit => 50
    t.string   "BillingStreet",       :limit => 50
    t.string   "BillingCity",         :limit => 50
    t.string   "BillingZIP",          :limit => 10
    t.string   "BillingPhone",        :limit => 50
    t.string   "BillingEmail",        :limit => 50
    t.integer  "BillingState_ID"
    t.string   "Check",               :limit => 50
    t.string   "PayPalAccount",       :limit => 50
    t.string   "WebSite",             :limit => 50
    t.string   "LogoGUID",            :limit => 40
    t.string   "PartnerName",         :limit => 50
    t.boolean  "IsActivated",                                                       :default => false
    t.integer  "Logins",              :limit => 8,                                  :default => 0,     :null => false
    t.string   "logo_file_name"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "logo_content_type"
  end

  add_index "partners", ["State_ID"], :name => "State_ID"

  create_table "payments", :force => true do |t|
    t.boolean  "IsDeleted",                                                   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "PaymentType_ID",                                                                 :null => false
    t.boolean  "IsTakeMoney",                                                                    :null => false
    t.string   "PaymentStatus",  :limit => 50
    t.datetime "PaymentDate",                                                                    :null => false
    t.string   "TransactionID",  :limit => 50
    t.decimal  "FeeAmount",                    :precision => 11, :scale => 2
    t.decimal  "GrossAmount",                  :precision => 11, :scale => 2
  end

  add_index "payments", ["PaymentType_ID"], :name => "typepayment_payments_fk"

  create_table "product_attachments", :force => true do |t|
    t.string   "title",                           :limit => 100
    t.integer  "product_id"
    t.string   "product_attachment_file_name"
    t.integer  "product_attachment_file_size"
    t.datetime "product_attachment_updated_at"
    t.string   "product_attachment_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_images", :force => true do |t|
    t.integer  "product_id",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "product_image_file_name"
    t.integer  "product_image_file_size"
    t.datetime "product_image_updated_at"
    t.string   "product_image_content_type"
  end

  add_index "product_images", ["id"], :name => "id", :unique => true
  add_index "product_images", ["product_id"], :name => "productimages_fk"

  create_table "product_params", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                :default => false
    t.string   "Name",       :limit => 50,                    :null => false
    t.integer  "Product_ID",                                  :null => false
    t.integer  "Partner_ID"
    t.boolean  "IsTemplate",               :default => false
  end

  add_index "product_params", ["Partner_ID"], :name => "partners_product_params_fk"
  add_index "product_params", ["Product_ID"], :name => "products_product_params_fk"

  create_table "product_params2orders", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                      :default => false
    t.integer  "registry_item_id"
    t.integer  "Order2Product_ID"
    t.string   "Name",             :limit => 50,                    :null => false
    t.string   "Value",            :limit => 50,                    :null => false
  end

  add_index "product_params2orders", ["Order2Product_ID"], :name => "o2p_product_params2orders_fk"
  add_index "product_params2orders", ["registry_item_id"], :name => "r2p_product_params2orders_fk"

  create_table "product_statuses", :force => true do |t|
    t.string   "Name",        :limit => 20, :default => "",    :null => false
    t.string   "Description", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                 :default => false, :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "Name",                            :limit => 50,                                                     :null => false
    t.string   "Description",                     :limit => 900,                                 :default => "",    :null => false
    t.decimal  "MasterPrice",                                     :precision => 11, :scale => 2,                    :null => false
    t.integer  "ProductStatus_ID",                                                               :default => 3,     :null => false
    t.integer  "Brand_ID"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                                                                      :default => false, :null => false
    t.integer  "Registrant_ID"
    t.integer  "ShipmentCategory_ID"
    t.boolean  "IsKind",                                                                         :default => false
    t.boolean  "IsKindView",                                                                     :default => true
    t.decimal  "SalesPrice",                                      :precision => 11, :scale => 2
    t.integer  "ShipmentType",                                                                   :default => 1
    t.decimal  "ShipmentCost",                                    :precision => 11, :scale => 2
    t.integer  "PartnerProduct_ID"
    t.integer  "count_view",                                                                     :default => 0,     :null => false
    t.integer  "priority",                                                                       :default => 0,     :null => false
    t.string   "source_url",                      :limit => 1024
    t.string   "source_name",                     :limit => 50
    t.boolean  "external",                                                                       :default => false
    t.string   "ext_color",                       :limit => 50
    t.string   "ext_size",                        :limit => 50
    t.string   "ext_other",                       :limit => 100
    t.string   "main_product_thumb_file_name"
    t.integer  "main_product_thumb_file_size"
    t.datetime "main_product_thumb_updated_at"
    t.string   "main_product_thumb_content_type"
    t.string   "main_product_image_file_name"
    t.integer  "main_product_image_file_size"
    t.datetime "main_product_image_updated_at"
    t.string   "main_product_image_content_type"
  end

  add_index "products", ["Brand_ID"], :name => "brands_products_fk"
  add_index "products", ["ProductStatus_ID"], :name => "products_fk"
  add_index "products", ["Registrant_ID"], :name => "registrant_products_fk"
  add_index "products", ["ShipmentCategory_ID"], :name => "category_products_fk"

  create_table "products2categories", :force => true do |t|
    t.integer  "Product_ID",                     :null => false
    t.integer  "Category_ID",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",   :default => false, :null => false
  end

  add_index "products2categories", ["Category_ID"], :name => "categories_products_to_categories_fk"
  add_index "products2categories", ["Product_ID"], :name => "products_products_to_categories_fk"

  create_table "products2colors", :force => true do |t|
    t.integer  "Product_ID",                    :null => false
    t.integer  "Color_ID",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",  :default => false, :null => false
  end

  add_index "products2colors", ["Color_ID"], :name => "color_products_to_colors_fk"
  add_index "products2colors", ["Product_ID"], :name => "products_products_to_colors_fk"

  create_table "products2stores", :force => true do |t|
    t.integer  "Product_ID",                    :null => false
    t.integer  "Store_ID",                      :null => false
    t.boolean  "IsDeleted",  :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products2stores", ["Product_ID"], :name => "products_products2stores_fk"
  add_index "products2stores", ["Store_ID"], :name => "stores_products2stores_fk"

  create_table "registrant_types", :force => true do |t|
    t.string   "Name",       :limit => 50, :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                :default => false, :null => false
  end

  create_table "registrants", :force => true do |t|
    t.string   "Email",                      :limit => 60,                                 :default => "",    :null => false
    t.string   "Password",                   :limit => 50,                                 :default => "",    :null => false
    t.string   "FirstName",                  :limit => 30,                                 :default => ""
    t.string   "LastName",                   :limit => 30,                                 :default => ""
    t.string   "FirstNameCoCreated",         :limit => 30,                                 :default => ""
    t.string   "LastNameCoCreated",          :limit => 30,                                 :default => ""
    t.string   "Address",                    :limit => 50,                                 :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                                                                :default => false, :null => false
    t.string   "ZIP",                        :limit => 10
    t.string   "PhoneNumber",                :limit => 20
    t.integer  "RegistryType_ID"
    t.string   "Description",                :limit => 600
    t.string   "City",                       :limit => 50
    t.integer  "State_ID"
    t.datetime "EventDate"
    t.string   "ImageGUID",                  :limit => 40
    t.decimal  "Cash",                                      :precision => 11, :scale => 2, :default => 0.0,   :null => false
    t.string   "fbuid",                      :limit => 32
    t.integer  "PaymentSystem",                                                            :default => 0
    t.string   "EventLocation"
    t.boolean  "IsActivated",                                                              :default => false
    t.integer  "Logins",                     :limit => 8,                                  :default => 0,     :null => false
    t.boolean  "is_invited",                                                               :default => false
    t.string   "profile_image_file_name"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string   "profile_image_content_type"
    t.boolean  "invite_friends_shown"
  end

  add_index "registrants", ["City"], :name => "couples_cities_fk"
  add_index "registrants", ["Email", "IsDeleted"], :name => "index_registrants_on_Email_and_IsDeleted", :unique => true
  add_index "registrants", ["RegistryType_ID"], :name => "couples_registryTypes_fk"
  add_index "registrants", ["State_ID"], :name => "states_couples_fk"
  add_index "registrants", ["fbuid", "IsDeleted"], :name => "index_registrants_on_fbuid_and_IsDeleted", :unique => true

  create_table "registry_items", :force => true do |t|
    t.integer  "Product_ID",                                                       :null => false
    t.integer  "Registrant_ID",                                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                                     :default => false, :null => false
    t.decimal  "Price",          :precision => 11, :scale => 2,                    :null => false
    t.integer  "Quantity",                                      :default => 1,     :null => false
    t.integer  "Color_ID"
    t.integer  "Purchased_ID"
    t.decimal  "Contributed",    :precision => 11, :scale => 2, :default => 0.0,   :null => false
    t.boolean  "IsGetMoney"
    t.decimal  "Tax",            :precision => 11, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "Shipment",       :precision => 11, :scale => 2, :default => 0.0,   :null => false
    t.boolean  "IsToolbar",                                     :default => false, :null => false
    t.integer  "section_id"
    t.integer  "order"
    t.integer  "copied_from_id"
  end

  add_index "registry_items", ["Color_ID"], :name => "colors_registrant2products_fk"
  add_index "registry_items", ["Product_ID"], :name => "products_couples2products_fk"
  add_index "registry_items", ["Registrant_ID"], :name => "couples_couples2products_fk"

  create_table "sections", :force => true do |t|
    t.string   "title",         :limit => 50
    t.string   "description",   :limit => 300
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "registrant_id"
  end

  add_index "sections", ["registrant_id"], :name => "registrant_fk"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :limit => 5000, :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id", :length => {"session_id"=>255}

  create_table "shippingmethods", :force => true do |t|
    t.string   "Name",       :limit => 50,                                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                                               :default => false, :null => false
    t.decimal  "Price",                    :precision => 11, :scale => 0,                    :null => false
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "create_at"
    t.datetime "updated_at"
    t.datetime "update_at"
  end

  create_table "states", :force => true do |t|
    t.string   "Name",       :limit => 50, :default => "",    :null => false
    t.boolean  "IsDeleted",                :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "GeneralTax",               :default => 0.0,   :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "Name",        :limit => 50,       :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                       :default => false, :null => false
    t.string   "City",        :limit => 50,       :default => ""
    t.integer  "State_ID"
    t.string   "Description", :limit => 300
    t.string   "Street",      :limit => 50
    t.string   "ZIP",         :limit => 10
    t.string   "Phone",       :limit => 50
    t.string   "Web",         :limit => 50
    t.string   "Email",       :limit => 50
    t.datetime "LastVisited"
    t.integer  "PartnerID",                                          :null => false
    t.boolean  "IsDefault",                       :default => false
    t.binary   "Image",       :limit => 16777215
    t.string   "ImageGUID",   :limit => 40
    t.integer  "Category_ID",                     :default => 0,     :null => false
    t.boolean  "visible",                         :default => false
  end

  add_index "stores", ["City"], :name => "cities_stores_fk"
  add_index "stores", ["PartnerID"], :name => "PartnerID"
  add_index "stores", ["State_ID"], :name => "states_stores_fk"

  create_table "typepayments", :force => true do |t|
    t.string   "Name",       :limit => 50,                    :null => false
    t.boolean  "IsDeleted",                :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "value_params", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "IsDeleted",                     :default => false
    t.string   "Value",           :limit => 20,                    :null => false
    t.integer  "ProductParam_ID",                                  :null => false
  end

  add_index "value_params", ["ProductParam_ID"], :name => "product_params_value_params_fk"

  create_table "withdrawals", :force => true do |t|
    t.integer  "Registrant_ID",                                                      :null => false
    t.integer  "Order_ID",                                                           :null => false
    t.boolean  "IsDeleted",                                       :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "Cash",             :precision => 11, :scale => 2
    t.decimal  "Tax",              :precision => 11, :scale => 2, :default => 0.0
    t.integer  "registry_item_id"
  end

  add_index "withdrawals", ["Order_ID"], :name => "orders_withdrawals_fk"
  add_index "withdrawals", ["Registrant_ID"], :name => "registrants_withdrawals_fk"
  add_index "withdrawals", ["registry_item_id"], :name => "registry_items_withdrawals_fk"

end
