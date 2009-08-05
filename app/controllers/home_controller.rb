class HomeController < ApplicationController
  def index
    @categories = Category.roots
#    render :file=>"public/500"
  end

end
