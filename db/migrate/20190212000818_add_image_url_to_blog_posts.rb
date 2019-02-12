class AddImageUrlToBlogPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :blog_posts, :image_url, :string, null: true
  end
end
