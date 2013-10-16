class AddMetaDataToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :etag, :string
    add_column :feeds, :last_modified, :datetime
  end
end
