class Admin::ResultsController < Admin::ApplicationController

  require_role :user

  before_filter :find_source

  def index
    @results = @source.results.paginate :page => params[:page], :order => :id
  end

  def export
    @results = @source.results.updated
  end

  def move

    params[:result_records].each do |result_id, result_attr|
      result = Result.find result_id

      if result_attr[:head]
        storage_attr_array = result_attr.keys.map{|key| key if key.to_s  =~ /^accept_\.*/ }.compact.map { |accepted_key|
         [accepted_key.sub('accept_','').to_sym, result_attr[accepted_key.sub('accept_','').to_sym]]
         }.flatten

        storage_attr_hash = Hash[*storage_attr_array]

        
        if result.storage
          result.storage.update_attributes storage_attr_hash
        else
          Storage.create(storage_attr_hash).results << result
        end


        if result.company

#          result.company.update_attributes storage_attr_hash

        else
          company = Company.create :name => storage_attr_hash[:name],
                                   :full_name => storage_attr_hash[:name],
                                   :address => storage_attr_hash[:address],
                                   :site => storage_attr_hash[:site_url],
                                   :working_time => storage_attr_hash[:work_time]

          company.phones << Phone.create(:number => storage_attr_hash[:phones]) if storage_attr_hash[:phones]
          company.emails << Email.create(:email => storage_attr_hash[:email])   if storage_attr_hash[:email]

          company.results << result
        end

      end

      result.update_attributes :is_updated => false, :is_checked => false
    end

    redirect_to export_admin_source_results_path(@source)
  end

private

  def find_source
    @source = Source.find(params[:source_id])
  end

end

