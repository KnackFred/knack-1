class Admin::ProductsController < ApplicationController
  layout "admin"
  before_filter :set_partner

  # GET /admin/products
  def index
    if params[:filter].blank?
      @filter = FilterProduct.new
    else
      @filter = FilterProduct.new(params[:filter])
    end

    @filter.partner_id = @partner.id unless @is_admin

    @products = Product.get_query_find_products_for_partner(@filter)
  end

  # GET /admin/products/new
  def new
    @product = Product.new
    @product_params = ProductParams.new(@product.product_params,2)
  end

  # GET /admin/products/1
  def show
    redirect_to edit_admin_product_path(params[:id])
  end

  # GET /admin/products/1/edit
  def edit
    @product = Product.find(params[:id])
    raise Exceptions::AccessDenied unless @is_admin || @product.stores.first.partner == @partner
    @product_params = ProductParams.new(@product.product_params,2)
  end

  # POST /admin/products
  def create

    # set brand
    params[:product][:Brand_ID] = Brand.get_brand_id_from_product_params(params[:product])

    @err_params = ""
    pp = params[:list_params].blank? ? [] : JSON.parse(params[:list_params])
    @product_params = ProductParams.new(pp,1)

    unless @product_params.valid?
      @err_params = StaticDataUtilities.get_prepare_error_message + "can't be blank"
      render :new
      return
    end

    ################# Create PRODUCT
    @product = Product.new(params[:product])

    if @product.save
      expire_brands_cache
      flash.notice = "Product Created"
      redirect_to image_admin_product_path(@product)
    else
      render :new
      return
    end

    ################# set PARAMS
    @product.set_params(@product_params)

  end

  # PUT /admin/products/1
  def update

    @product = Product.find(params[:id])

    raise Exceptions::AccessDenied unless @is_admin || @product.stores.first.partner == @partner

    # set brand
    params[:product][:Brand_ID] = Brand.get_brand_id_from_product_params(params[:product])

    @err_params = ""
    pp = params[:list_params].blank? ? [] : JSON.parse(params[:list_params])
    @product_params = ProductParams.new(pp,1)

    unless @product_params.valid?
      @err_params = StaticDataUtilities.get_prepare_error_message + "can't be blank"
      render :edit
      return
    end

    ################# SAVE PRODUCT
    if @product.update_attributes(params[:product])
      flash.notice = "Product Updated"

      expire_brands_cache

      if params[:product][:main_product_image]
        redirect_to image_admin_product_path(@product)
      else
        redirect_to edit_admin_product_path(@product)
      end
    else
      render :edit
      return
    end

    ################# set PARAMS
    @product.set_params(@product_params)
  end

  # GET /admin/products/1/image
  # PUT /admin/products/1/image
  def image
    @product = Product.find(params[:id])
    raise Exceptions::AccessDenied unless @is_admin || @product.stores.first.partner == @partner

    unless request.get?
      if @product.update_attributes(params[:product])
        flash.notice = "Product Image Cropped"
        redirect_to edit_admin_product_path(@product)
        return
      end
    end
    render 'shared/crop_image', :layout => "empty", :locals => {:model => @product,  :attachment => :main_product_thumb, :action => "image"}
  end

  private

  def set_partner
    @partner = @current_partner
  end
end
