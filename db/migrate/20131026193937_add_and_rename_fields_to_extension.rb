class AddAndRenameFieldsToExtension < ActiveRecord::Migration
  def change
    add_column :extensions, :documentation_url, :string
    add_column :extensions, :watcher_count, :integer
    add_column :extensions, :last_pushed_at, :timestamp

    rename_column :extensions, :current_version, :version
    rename_column :extensions, :supports_sass_version, :supports
  end
end
