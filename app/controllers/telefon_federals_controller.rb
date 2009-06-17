class TelefonFederalsController < ApplicationController
  # GET /telefon_federals
  # GET /telefon_federals.xml
  def index
    @telefon_federals = TelefonFederal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @telefon_federals }
    end
  end

  # GET /telefon_federals/1
  # GET /telefon_federals/1.xml
  def show
    @telefon_federal = TelefonFederal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @telefon_federal }
    end
  end

  # GET /telefon_federals/new
  # GET /telefon_federals/new.xml
  def new
    @telefon_federal = TelefonFederal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @telefon_federal }
    end
  end

  # GET /telefon_federals/1/edit
  def edit
    @telefon_federal = TelefonFederal.find(params[:id])
  end

  # POST /telefon_federals
  # POST /telefon_federals.xml
  def create
    @telefon_federal = TelefonFederal.new(params[:telefon_federal])

    respond_to do |format|
      if @telefon_federal.save
        flash[:notice] = 'TelefonFederal was successfully created.'
        format.html { redirect_to(@telefon_federal) }
        format.xml  { render :xml => @telefon_federal, :status => :created, :location => @telefon_federal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @telefon_federal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /telefon_federals/1
  # PUT /telefon_federals/1.xml
  def update
    @telefon_federal = TelefonFederal.find(params[:id])

    respond_to do |format|
      if @telefon_federal.update_attributes(params[:telefon_federal])
        flash[:notice] = 'TelefonFederal was successfully updated.'
        format.html { redirect_to(@telefon_federal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @telefon_federal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /telefon_federals/1
  # DELETE /telefon_federals/1.xml
  def destroy
    @telefon_federal = TelefonFederal.find(params[:id])
    @telefon_federal.destroy

    respond_to do |format|
      format.html { redirect_to(telefon_federals_url) }
      format.xml  { head :ok }
    end
  end
end
