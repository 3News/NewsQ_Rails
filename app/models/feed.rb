# == Schema Information
#
# Table name: feeds
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Feed < ActiveRecord::Base
  has_many :feed_items, :dependent => :destroy
end
