class RemoveTagFromLinkAndAddTagGroupForLink < ActiveRecord::Migration
  def self.up
    add_column :links, :tag_group_id, :integer
    remove_column :links, :tag_id
  end

  def self.down
    remove_column :links, :tag_group_id, :integer
    add_column :links, :tag_id, :integer
  end
end
