class RemoveTagFromRetweetedUserAndAddTagGroupForRetweetedUser < ActiveRecord::Migration
  def self.up
    add_column :retweeted_users, :tag_group_id, :integer
    remove_column :retweeted_users, :tag_id
  end

  def self.down
    remove_column :retweeted_users, :tag_group_id
    add_column :retweeted_users, :tag_id, :integer
  end
end
