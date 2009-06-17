class Admin::StoragesController < Admin::ApplicationController
  layout 'admin'
  def index
    @storages = Storage.paginate :page => params[:page], :order => :id
  end

end
