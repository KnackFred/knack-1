class InfoController < ApplicationController

  #############################################################
  #  san_francisco
  #############################################################
  def san_francisco
    render :san_francisco, :layout => "empty-nav"
  end

  #############################################################
  #  san_francisco_fb
  #############################################################
  def san_francisco_fb
    render :san_francisco_fb, :layout => "empty"
  end

  #############################################################
  #  san_francisco_fb_liked
  #############################################################
  def san_francisco_fb_liked
    render :san_francisco_fb_liked, :layout => "empty"
  end

end



