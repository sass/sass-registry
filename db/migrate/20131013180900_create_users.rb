class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :company
      t.string :location
      t.string :website
      t.text :bio
      t.boolean :available_for_hire, default: false
      t.integer :extensions_count

      t.timestamps
    end
  end
end
