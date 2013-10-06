class FeedUpdateManager

  @queue = :update_feeds_queue

  def self.perform()
    @feeds = Feed.all
    @feeds.each { |f| puts f.url }
  end

end