class DropColumnTweetIdFromLinksTable < ActiveRecord::Migration
  def self.up
    remove_column :links, :tweet_id
  end

  def self.down
    add_column :links, :tweet_id, :integer
  end
end
