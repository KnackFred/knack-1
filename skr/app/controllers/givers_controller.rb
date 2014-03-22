class GiversController < ApplicationController
  #######################################################
  # ACTION GIVERS
  #######################################################
  def givers
    @givers = Contribute.where(:registry_item_id => params[:id])
  end
end
