class FeedItemsController < ApplicationController
  def index
    @feed_items = FeedItem.all
  end
end
