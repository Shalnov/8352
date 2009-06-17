class TelefonRenamesController < ApplicationController
  # GET /telefon_renames
  # GET /telefon_renames.xml
  def index
    @telefon_renames = TelefonRename.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @telefon_renames }
    end
  end

  # GET /telefon_renames/1
  # GET /telefon_renames/1.xml
  def show
    @telefon_rename = TelefonRename.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @telefon_rename }
    end
  end

  # GET /telefon_renames/new
  # GET /telefon_renames/new.xml
  def new
    @telefon_rename = TelefonRename.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @telefon_rename }
    end
  end

  # GET /telefon_renames/1/edit
  def edit
    @telefon_rename = TelefonRename.find(params[:id])
  end

  # POST /telefon_renames
  # POST /telefon_renames.xml
  def create
    @telefon_rename = TelefonRename.new(params[:telefon_rename])

    respond_to do |format|
      if @telefon_rename.save
        flash[:notice] = 'TelefonRename was successfully created.'
        format.html { redirect_to(@telefon_rename) }
        format.xml  { render :xml => @telefon_rename, :status => :created, :location => @telefon_rename }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @telefon_rename.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /telefon_renames/1
  # PUT /telefon_renames/1.xml
  def update
    @telefon_rename = TelefonRename.find(params[:id])

    respond_to do |format|
      if @telefon_rename.update_attributes(params[:telefon_rename])
        flash[:notice] = 'TelefonRename was successfully updated.'
        format.html { redirect_to(@telefon_rename) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @telefon_rename.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /telefon_renames/1
  # DELETE /telefon_renames/1.xml
  def destroy
    @telefon_rename = TelefonRename.find(params[:id])
    @telefon_rename.destroy

    respond_to do |format|
      format.html { redirect_to(telefon_renames_url) }
      format.xml  { head :ok }
    end
  end
end
