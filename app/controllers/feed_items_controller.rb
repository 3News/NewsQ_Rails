class FeedItemsController < ApplicationController
  def index
    @feed_items = FeedItem.paginate(
      :page => params[:page], :per_page => 50,
      :order => 'published_at DESC')
  end
end
