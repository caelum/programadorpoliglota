class AddColumnTagIdAtTableLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :tag_id, :integer
  end

  def self.down
    remove_column :links, :tag_id
  end
end
