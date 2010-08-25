class CreateColumnTitleAtLinksTable < ActiveRecord::Migration
  def self.up
    add_column :links, :title, :string
  end

  def self.down
    remove_column :links, :title
  end
end
