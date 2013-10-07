# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# config/seed_data_for_feed/tech_feed.xml를 parsing해서 Feed Model에 넣어준다.
# title / text / htmlUrl / type / xmlUrl

include W3CValidators

@validator = FeedValidator.new
def valid?(feed_url)
  results = @validator.validate_uri(feed_url)

  return results.errors.length == 0
end

def parse_opml_and_save(file_path)
  f = File.open(file_path)
  doc = Nokogiri::XML(f)
  items = doc.xpath("//outline")

  items.each do |i|
    feed_url = i['xmlUrl']
    # if valid?(feed_url)
    #   puts "#{feed_url} valid"
    # else
    #   puts "#{feed_url} invalid"
    # end

    Feed.create(name: i['title'], url: i['xmlUrl'], category: 'tech')
  end

  f.close()
end

# https://gist.github.com/pauldix/57285
def parse_feed_and_save(feed_items)
  feed_urls = feed_items.collect { |f| f.url }
  feeds = Feedzirra::Feed.fetch_and_parse(feed_urls)

  feed_items.each do |f|
    feed = feeds[f.url]
    next if feed.is_a? Fixnum or feed.nil?

    entries = feed.entries
    entries.delete_if {|x| x == nil}

    entries.each do |e|
      FeedItem.create(feed_id: f.id, title: e.title, author: e.author,
        content: e.content.nil? ? e.summary : e.content, link: e.url, published_at: e.published)
    end
  end
end

tech_xml_path = Rails.root.join("config/seed_data_for_feed", "tech_feed.xml")
parse_opml_and_save(tech_xml_path)
parse_feed_and_save(Feed.all)

