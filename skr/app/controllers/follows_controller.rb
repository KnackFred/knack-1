class FollowsController < ApplicationController
  layout "registrant"
  # GET /follows
  def index
    @registrant = registrant
    @followed = registrant.followed_registrants

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # POST /follows.json
  def create
    @follow = registrant.follows.new(:followed_id => params[:id])

    respond_to do |format|
      if @follow.save
        format.json  { render :json => @follow, :status => :created, :location => @follow }
      else
        format.json  { render :json => @follow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1.json
  def destroy
    @follow = registrant.follows.find_by_followed_id(params[:id])
    @follow.destroy

    respond_to do |format|
      format.json  { head :ok }
    end
  end

  # post /follows/follow_fb_friends
  def follow_fb_friends
    registrant.follow_fb_friends params[:friends] if params[:friends]

    head :ok
  end

end
