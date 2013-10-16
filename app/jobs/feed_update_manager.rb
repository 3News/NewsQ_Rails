class FeedUpdateManager
  @queue = :update_feeds_queue

  # redis-server /usr/local/etc/redis.conf
  # rake resque:scheduler
  # rake resque:work
  def self.perform()
    feed_models = Feed.all
    feed_models.each do |f|
      if f.etag == nil and f.last_modified == nil
        next
      end

      feed_instance = Feedzirra::Parser::Atom.new
      feed_instance.feed_url = f.url
      feed_instance.etag = f.etag
      feed_instance.last_modified = f.last_modified

      query_result = FeedItem.where("feed_id = ?", f.id).order('published_at desc').limit(1)
      entry = query_result.first
      if entry == nil or entry.link == nil
        next
      end

      last_entry_instance = Feedzirra::Parser::AtomEntry.new
      last_entry_instance.url = entry.link

      feed_instance.entries = [last_entry_instance]

      feed_checker = Feedzirra::Feed.update(feed_instance)
      if feed_checker.respond_to?('new_entries')
        entries = feed_checker.new_entries
        entries.delete_if {|x| x == nil}

        if entries.size > 0
          puts "feed update ... #{f.url}"

          entries.each do |e|
            FeedItem.create(feed_id: f.id, title: e.title, author: e.author,
              content: e.content.nil? ? e.summary : e.content, link: e.url, published_at: e.published)
          end

          if f.etag != feed_checker.etag or f.last_modified != feed_checker.last_modified
            f.update_attributes(etag: f.etag, last_modified: f.last_modified)
          end
        end
      end
    end
  end
end
