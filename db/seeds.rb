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

  feeds = []
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

# tech
tech_xml_path = File.join(Rails.root, "config/seed_data_for_feed", "tech_feed.xml")
feed_items = parse_opml(tech_xml_path)
