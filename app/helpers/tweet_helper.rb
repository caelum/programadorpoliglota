module TweetHelper
  def next_page_link(page, tag)
    link_to 'Ver mais', see_more_url(:page=>page, :tag=>tag), :class=>'ver_mais'
  end
  
  def previous_page_link(page, tag)
    link_to 'Anteriores', see_more_url(:page=>page - 2, :tag=>tag), :class=>'ver_mais'
  end
end
