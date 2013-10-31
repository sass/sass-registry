class GenerateSlugsForExtensions < ActiveRecord::Migration
  def up
    Extension.all.each do |extension|
      extension.save!
    end
  end
end
