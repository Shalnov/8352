class Admin::LinksController < Admin::ApplicationController

  layout 'admin'

  def index
    @links = Link.all
  end

end
