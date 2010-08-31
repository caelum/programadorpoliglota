class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.string :name
      t.string :url
      t.boolean :approved, :default=>false
      t.integer :tag_id
      t.timestamps
    end
  end

  def self.down
    drop_table :communities
  end
end
