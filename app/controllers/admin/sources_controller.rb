class Admin::SourcesController < Admin::ApplicationController
  
  layout 'admin'

  require_role :admin

  before_filter :collect_new_grabber_modules, :only => [:index, :new]

  def run
    source = Source.find params[:id]
    source.jobs.destroy_all
    source.jobs.enqueue!(Processing, :run_grabber, source.id)

    redirect_to admin_sources_path
  end

  def index
    @sources = Source.all
  end

  def show
    @source = Source.find(params[:id])

    respond_to do |format|
      format.js do
        render :update do |page|
          page[@source.jobs.first].replace_html :partial => "source"
        end
      end
    end

  end

  def new
    @source = Source.new
  end

  def create
    @source = Source.new(params[:source])

    if @source.save
      flash[:notice] = 'Source was successfully created.'
      redirect_to admin_sources_path
    else
      render :action => "new"
    end
  end

private

  def collect_new_grabber_modules
    Dir["#{RAILS_ROOT}/lib/grabber/*"].each { |file| require file }
    @new_grabber_modules = Grabber.constants - ["Base"] - Source.all.map{ |s| s.grabber_module }
  end

end
