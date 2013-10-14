class CreateExtensions < ActiveRecord::Migration
  def change
    create_table :extensions do |t|
      t.string :name
      t.string :description, limit: 1000
      t.text :installation_instructions
      t.string :supports_sass_version
      t.string :repository_url
      t.string :repository_type
      t.string :download_url
      t.string :download_type
      t.string :homepage_url
      t.string :current_version
      t.integer :author_id
      t.timestamps
    end
  end
end
