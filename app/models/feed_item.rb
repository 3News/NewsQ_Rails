# == Schema Information
#
# Table name: feed_items
#
#  id           :integer          not null, primary key
#  feed_id      :integer          not null
#  title        :string(255)
#  author       :string(255)
#  content      :text
#  link         :string(255)
#  published_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class FeedItem < ActiveRecord::Base
  belongs_to :feed
end
