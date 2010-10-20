class TweetObserver < ActiveRecord::Observer
  def after_create(obj)
    clean_cache
  end

  def clean_cache
    file_name = 'public/index.html'
    if File.exists? file_name
      File.delete file_name
    end
  end
end
