module TweetHelper
  def next_page_link(page, tag)
    link_to 'Ver mais', see_more_url(:page=>page, :tag=>tag), :class=>'ver_mais'
  end
end
