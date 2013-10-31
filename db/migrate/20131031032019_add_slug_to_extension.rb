class AddSlugToExtension < ActiveRecord::Migration
  def change
    add_column :extensions, :slug, :string
  end
end
