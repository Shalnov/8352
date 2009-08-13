class ChangeDescriptionsInCategory < ActiveRecord::Migration
  def self.up
    change_column :categories, :description, :text, :null=>true
  end

  def self.down
  end
end
