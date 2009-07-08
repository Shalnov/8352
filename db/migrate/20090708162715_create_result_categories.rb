class CreateResultCategories < ActiveRecord::Migration
  def self.up
    create_table :result_categories do |t|
      t.string :category
      t.references :category
      t.references :storage

      t.timestamps
    end
    add_index :result_categories, [:category_id, :storage_id], :unique => true
  end

  def self.down
    drop_table :result_categories
  end
end
