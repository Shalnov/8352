# -*- coding: utf-8 -*-
class CreateTelefonRenames < ActiveRecord::Migration
  def self.up
    create_table :telefon_renames do |t|
      t.string :old
      t.string :new
      t.date   :rename_date # Дата переименования. 
      t.timestamps
    end
    
    add_index :telefon_renames, :old, :unique=>true
    add_index :telefon_renames, :new, :unique=>true
  end

  def self.down
    drop_table :telefon_renames
  end
end
