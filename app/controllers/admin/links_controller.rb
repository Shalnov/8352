class Admin::LinksController < Admin::ApplicationController

  def index
    @links = Link.all
  end

end
