module HomeHelper
  def next_page_link(page, tag_group)
    link_to 'Ver mais', see_more_url(:page=>page + 1, :tag_group=>tag_group), :class=>'ver_mais btnMoreTweets'
  end
  
  def previous_page_link(page, tag_group)
    link_to 'Anteriores', see_more_url(:page=>page - 1, :tag_group=>tag_group), :class=>'ver_mais btnMoreTweets'
  end
  
  def image_url_of(user)
    user.image_url ||= '/images/default_twitter.png'
  end
  
  def replace_text_links_for_clickable_links(text)
    text.sub(/http[s]?:\/\/+[\w\d:\#\@\%\/;\$\(\)\~\_\?\+\-\=\\\.&]+/) { |link| "<a href='#{link}' target='_blank'>#{link}</a>" }
  end
  
  def about_link(id)
    link_to raw('<span>Apoie o <br /> movimento</span>'), about_path, :id=>id
  end  
end
