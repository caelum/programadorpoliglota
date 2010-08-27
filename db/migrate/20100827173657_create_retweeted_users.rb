class CreateRetweetedUsers < ActiveRecord::Migration
  def self.up
    create_table :retweeted_users do |t|
      t.integer :user_id
      t.integer :tag_id
      t.integer :amount
      t.timestamps
    end
  end

  def self.down
    drop_table :retweeted_users
  end
end
