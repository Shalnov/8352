class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones, :id => false do |t|
      t.references  :company
      t.integer     :number,        :null => false, :precision => 11
      t.string      :person,        :length => 150
      t.string      :department,    :length => 300
      t.string      :working_time,  :length => 200
      t.string      :description,   :length => 1024

      t.references
    end

    add_index :phones, :company_id
    add_index :phones, :number, :unique => true
  end

  def self.down
    drop_table :phones
  end
end
