class CreateColumnQuantityAtLinksTable < ActiveRecord::Migration
  def self.up
    add_column :links, :quantity, :integer
  end

  def self.down
    remove_column :links, :quantity
  end
end
