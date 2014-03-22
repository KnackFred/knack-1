class Admin::PartnerAdministratorsController < ApplicationController
  layout "admin"
  before_filter :set_partner

  # GET /admin/administrators
  def index
    if @is_admin
      @administrators = PartnerAdministrator.paginate(:page => params[:page], :per_page => 50)
    else
      @administrators = @partner.partner_administrators.paginate(:page => params[:page], :per_page => 50)
    end
  end

  # GET /admin/products/new
  def new
    @administrator = PartnerAdministrator.new
  end

  # GET /admin/products/1
  def show
    redirect_to edit_admin_partner_administrator_path(params[:id])
  end

  # GET /admin/products/1/edit
  def edit
    if @is_admin
      @administrator = PartnerAdministrator.find(params[:id])
    else
      @administrator = @partner.partner_administrators.find(params[:id])
    end
  end

  # POST /admin/products
  def create
    if @is_admin
      @administrator = PartnerAdministrator.new(params[:partner_administrator])
    else
      @administrator = @partner.partner_administrators.build(params[:partner_administrator])
    end

    if @administrator.save
      flash.notice = "Administrator Created"
      redirect_to admin_partner_administrators_path
      return
    else
      render :new
    end
  end

  # PUT /admin/products/1
  def update
    if @is_admin
      @administrator = PartnerAdministrator.find(params[:id])
    else
      @administrator = @partner.partner_administrators.find(params[:id])
    end

    if @administrator.update_attributes(params[:partner_administrator])
      flash.notice = "Administrator Updated"
      redirect_to admin_partner_administrators_path
    else
      render :edit
    end
  end

  # Delete /admin/products/1
  def delete
    if @is_admin
      administrator = PartnerAdministrator.find(params[:id])
    else
      administrator = @partner.partner_administrators.find(params[:id])
    end

    if administrator.delete
      flash.notice = "Administrator Deleted"
    end

    redirect_to admin_partner_administrators_path
  end

  private

  def set_partner
    @partner = @current_partner
  end

end
