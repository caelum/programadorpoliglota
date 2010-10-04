class AddTagQueryColumnToTagsTable < ActiveRecord::Migration
  def self.up
    add_column :tags, :query, :string
    Tag.all.each do |t|
      t.query = t.name
      t.save
    end
  end

  def self.down
    remove_column :tags, :query
  end
end
