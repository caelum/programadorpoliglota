class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :user
      t.datetime :date
      t.string :image_url
      t.string :text
      t.integer :tag_id
      t.string :tweet_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
