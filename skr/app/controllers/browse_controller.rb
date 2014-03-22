require 'mail_utilities'
require 'cart'
require 'math_utilite'
require 'uri'
require 'net/http'
require 'pdf/reader'
require "product_params"
require 'thinking_sphinx'
class BrowseController < ApplicationController

  caches_page :brands
  caches_page :stores

  layout 'registrant'
  ################################################
  # ACTION Category
  ################################################
  def catalog
    @registrant = registrant

    # Find by name products
    if params[:findtext].blank? || params[:findtext].strip == "Type gift name"
      @findtext = ''
    else
      @findtext = params[:findtext]
    end

    # Left value "price slider"
    @valleft = params[:valleft].blank? ? 0 : params[:valleft].to_i
    # Right value "price slider"
    @valright = params[:valright].blank? ? 0 : params[:valright].to_i

    unless params[:use_cat_link].blank?
      @findtext = ''
      @valleft = 0
      @valright = 0
    end

    # per page
    per_page = params[:per_page].blank? ? 32 : params[:per_page]

    # current page
    page  = params[:page].blank? ? 1 : params[:page]

    # Current category id
    category_id = params[:id].blank? ? Category.root.id : params[:id]
    unless Category.exists?(category_id)
      category_id = Category.root.id
    end

    # Type param
    @param = params[:param].blank? ? '' : params[:param]

    # Value param
    @valparam = params[:valparam].blank? ? '' : params[:valparam]

    if @param == 's'
      @store = Store.find(@valparam)
    end

    if @param == 'b'
      @brand = Brand.find(@valparam)
    end

    # Current category
    @category = Category.find_by_id(category_id)
    ids = @category.get_ids_with_children
    product_params = FindProductParams.new(page, per_page, @param, @valparam)
    product_params.find_text = @findtext
    product_params.value_left = @valleft
    product_params.value_right = @valright

    # if redirect from item page
    if request.post? && !params[:back_view].blank?
      unless session[:product_params].blank?
        product_params = session[:product_params]
        @findtext = product_params.find_text
        @valleft = product_params.value_left
        @valright = product_params.value_right
      end
    end
    session[:back_path] = catalog_path(category_id)

    # Get prices for slider
    @prices = Product.get_product_prices(@findtext, product_params, ids)
    @count_values = @prices.length

    #################################
    # list unique price
    #################################
    @values = @prices.to_sentence(:words_connector => ',', :two_words_connector => ',', :last_word_connector => ',')

    #################################
    # For Slider
    #################################
    if @valright == 0 || @valright.to_i > @count_values -1
      @valright = @count_values -1
    end

    if !@prices.blank? && @prices.length > 2
      if @valleft.to_i >= @prices.length
        @valleft = 0
      end

      if @valright.to_i >= @prices.length
        @valright = @prices.length - 1
      end
      min_price = @prices[@valleft]
      max_price = @prices[@valright]
    else
      min_price = 0
        max_price = 0
      end

      product_params.max_price = max_price
      product_params.min_price = min_price

      @count_gifts = Product.get_count_products(@findtext, product_params, ids)

    # Check last page
    if (product_params.page.to_i - 1)*product_params.per_page.to_i >= @count_gifts
      product_params.page = 1
    end

    session[:product_params] = product_params
    @products = Product.find_all_view_catalog(@findtext, product_params, ids)

    @findtext = 'Type gift name' if params[:findtext].blank? || params[:findtext].strip == "Type gift name"
  end

  ################################################
  # ACTION Search (AJAX)
  ################################################
  def search
    text = params[:query]
    category_id = params[:cid]
    list = Product.search_by_name_and_brand(text)
    json = Json_search.new
    json.query = text
    list.each do |l|
      if l.categories.first
        json.suggestions << "#{l.categories.first.name} > #{l.Name}"
        json.data << from_catalog_path(category_id, l.id, l.name_url)
      end
    end
    # json.suggestions.sort
    render :json => json
  end

  ################################################
  # ACTION Suggest
  ################################################
  def suggest_products

    @products = Product.search_by_name_and_brand(params[:query], 4)

    render :text => 'knackLoadSuggestions('+@products.to_json(:only => [:id, :Name], :methods => [:Price, :small_thumb_url])+');'

  end

  ################################################
  # ACTION STORES
  ################################################
  def stores
    @registrant = registrant
    @categories = Category.with_stores.includes(:stores)

    render :stores, :layout => 'empty'
  end

  ################################################
  # ACTION BRANDS
  ################################################
  def brands
    @registrant = registrant

    @array = Brand.find_all_with_products
    render :brands, :layout => 'empty'
  end

  ################################################
  # ACTION Feed
  ################################################
  def feed
    @registrant = registrant
    @category = Category.hot
    @site = params[:site]
    @registry_items = RegistryItem.get_feed_items(params[:filter], @registrant, @site).paginate(:page => params[:page], :per_page => 40)
  end

  ################################################
  # ACTION ITEM
  ################################################
  def item
    @registrant = registrant

    @product = Product.find(params[:id])
    registry_id = params[:r]
    registry_item_id = params[:r2p]
    @in_cart = false

    raise ActiveRecord::RecordNotFound if registry_item_id.blank? && !@product.available?

    unless registry_id.blank? || registry_item_id.blank?
      @registry = Registrant.find(registry_id)
      raise ActiveRecord::RecordNotFound if @registry.IsDeleted?

      @registry_item = RegistryItem.find(registry_item_id)
      raise ActiveRecord::RecordNotFound if @registry_item.IsDeleted?

      @in_cart = Cart.registry_item_in_cart?(session, @registry_item.id)
    end

    @category_id = params[:c].blank? ? Category.root.id : params[:c]

    @category = Category.find(@category_id)

    @product.increment!(:count_view)

    # Information for the BCT and the partner bio section.
    @brand = Brand.find(params[:b]) unless params[:b].nil?
    if params[:s].nil?
      @partner = @product.get_default_store && @product.get_default_store.partner
    else
      @store = Store.find(params[:s])
      @partner = @store.partner
    end
  end
end
