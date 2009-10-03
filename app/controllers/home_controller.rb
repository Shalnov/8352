class HomeController < ApplicationController

  access_control do
     allow all
  end
  
  def index
    @company_branches = Branch.roots.all :order => :name
  end

end
