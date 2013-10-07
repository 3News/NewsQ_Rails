class FeedItemsController < ApplicationController
  def index
    @feed_items = FeedItem.order('published_at DESC')
  end
end
