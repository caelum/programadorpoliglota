class CreateColumnLinksExtractedAtTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :links_extracted, :boolean
  end

  def self.down
    remove_column :tweets, :links_extracted
  end
end
