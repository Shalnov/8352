class HomeController < ApplicationController
  def index
    @company_branches = Branch.roots
#    render :file=>"public/500"
  end

end
