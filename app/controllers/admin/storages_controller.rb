class Admin::StoragesController < Admin::ApplicationController

  def index
    @storages = Storage.paginate :page => params[:page], :order => :id
  end

end
