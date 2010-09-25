class RemoveTagFromTweetAndAddTagGroupForTweet < ActiveRecord::Migration
  def self.up
    add_column :tweets, :tag_group_id, :integer
    remove_column :tweets, :tag_id
  end

  def self.down
    remove_column :tweets, :tag_group_id
    add_column :tweets, :tag_id, :integer
  end
end
