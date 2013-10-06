class FeedUpdateManager
  @queue = :update_feeds_queue

  def self.perform()
    feed_urls = Feed.all
    feeds = Feedzirra::Feed.fetch_and_parse(feed_urls)
  end
end