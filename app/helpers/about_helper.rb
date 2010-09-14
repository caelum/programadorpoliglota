module AboutHelper
  def about_link(id)
    link_to raw('<span>Apoie o <br /> movimento</span>'), about_path, :id=>id
  end  
end
