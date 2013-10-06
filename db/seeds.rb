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

def parse_opml(file_path)
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

# tech feed
tech_xml_path = Rails.root.join("config/seed_data_for_feed", "tech_feed.xml")
parse_opml(tech_xml_path)

# tech feed items
feeds = Feed.all
feeds.each do |f|
  begin
    feed = Feedzirra::Feed.fetch_and_parse(f.url)
    feed.entries.each do |e|
      FeedItem.create(feed_id: f.id, title: e.title, author: e.author,
        content: e.content, link: e.url, published_at: e.published)
    end
  rescue Exception => e
    puts "error occured. #{f.url}"
    next
  end
end