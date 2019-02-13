class Git::SyncBlogPosts
  include Mandate

  def initialize(repo = Git::BlogRepository.head)
    @repo = repo
  end

  def call
    upsert_blog_posts!
    delete_old_blog_posts!
  end

  private
  def upsert_blog_posts!
    @blog_post_ids ||= repo.blog_posts.map do |blog_post_data|
      blog_post = upsert_blog_post!(blog_post_data)
      blog_post.id
    end
  end

  def upsert_blog_post!(blog_post_data)
    blog_post = BlogPost.find_or_initialize_by(uuid: blog_post_data[:uuid])

    blog_post.tap do |blog_post|
      blog_post.assign_attributes(
        slug: blog_post_data[:slug],
        category: blog_post_data[:category],
        published_at: Time.parse(blog_post_data[:published_at]),
        title: blog_post_data[:title],
        author_handle: blog_post_data[:author_handle],
        marketing_copy: blog_post_data[:marketing_copy],
        content_repository: blog_post_data[:content_repository],
        content_filepath: blog_post_data[:content_filepath],
        image_url: blog_post_data[:image_url].presence
      )
      blog_post.save!
    end
  end

  def delete_old_blog_posts!
    #blog_post.where.not(id: blog_post_ids).destroy_all
  end

  attr_reader :blog_post_ids, :repo
end

