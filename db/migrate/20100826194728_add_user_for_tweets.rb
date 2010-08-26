class AddUserForTweets < ActiveRecord::Migration
  def self.up
    remove_column :tweets, :user
    remove_column :tweets, :image_url
    add_column :tweets, :user_id, :integer
  end

  def self.down
    add_column :tweets, :user, :string
    add_column :tweets, :image_url, :string
    remove_column :tweets, :user_id
  end
end
