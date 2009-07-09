class ImportWorker

  def categories_import()
    Import::Category.run
  end
  
  def run_import()
    Import::Importer.run
  end

end
