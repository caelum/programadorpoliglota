class RemoveAmountForRetweetedUsers < ActiveRecord::Migration
  def self.up
    RetweetedUser.all.each do |retweeted_user|
      retweeted_user.amount.times do 
        RetweetedUser.create :user_id=>retweeted_user.user_id, :tag_group_id=>retweeted_user.tag_group_id
      end
    end
    remove_column :retweeted_users, :amount
  end

  def self.down
    add_column :retweeted_users, :amount, :integer
  end
end
