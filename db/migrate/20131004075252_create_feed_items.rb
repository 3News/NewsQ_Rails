class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.references :feed, :null => false
      t.string :title
      t.string :author
      t.text :content
      t.string :link
      t.datetime :published_at

      t.timestamps
    end

    add_index :feed_items, :feed_id
  end
end
