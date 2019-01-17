class Git::BlogRepository < Git::RepoBase
  if Rails.env.development?
    REPO_URL="file://#{Rails.root}/../blog"
  else
    REPO_URL="https://github.com/exercism/blog"
  end

  def self.repo_url
    REPO_URL
  end

  def self.head
    new(repo_url)
  end

  def initialize(repo_url, auto_fetch=false)
    super
  end

  def blog_posts
    config_pointer = head_commit.tree['blog.json']
    config_blob = lookup(config_pointer[:oid])
    read_json_blob(config_pointer[:oid])
  end

  def blog_post_content(filepath)
    # We want to strip out the posts/ path and just have a filename
    # We're not supporting nested things atm.
    filename = filepath.gsub(/^posts\//, "")
    ptr = head_commit.tree["posts"]
    tree = repo.lookup(ptr[:oid])
    tree.walk_blobs do |root, file|
      next unless file[:name] == filename
      file_blob = repo.lookup(file[:oid])
      return file_blob.text
    end
  end
end
