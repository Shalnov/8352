class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.references :source, :parent
      t.string  :name, :url
      t.boolean :is_follow, :default => true
      t.integer :links_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
