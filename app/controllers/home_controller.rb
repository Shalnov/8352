class HomeController < ApplicationController
  def index
    @company_branches = Branch.roots.all :order => :name
#    render :file=>"public/500"
  end

end
