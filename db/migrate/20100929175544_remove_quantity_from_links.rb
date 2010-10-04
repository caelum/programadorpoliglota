class RemoveQuantityFromLinks < ActiveRecord::Migration
  def self.up
    Link.all.each do |link|
      link.quantity.times do
        Link.create :url => link.url, :title => link.title
      end  
    end 
    remove_column :links, :quantity
  end

  def self.down
    add_column :links, :quantity, :integer
  end
end
