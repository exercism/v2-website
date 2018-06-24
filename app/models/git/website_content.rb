class Git::WebsiteContent < Git::RepoBase

  if Rails.env.development?
    REPO_URL="file://#{Rails.root}/../website-copy"
  else
    REPO_URL="https://github.com/exercism/website-copy"
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

  def ==(other)
    repo_url == other.repo_url
  end

  def pages
    FolderReader.new(self, head_commit, 'pages')
  end

  def walkthrough
    FolderReader.new(self, head_commit, 'walkthrough')
  end

  class FolderReader
    attr_reader :repo, :head_commit, :folder_name

    def initialize(repo, head_commit, folder_name)
      @repo = repo
      @head_commit = head_commit
      @folder_name = folder_name
    end

    def [](slug)
      file = ptr_for(slug)
      return nil if file.nil?
      repo.read_blob(file[:oid])
    end

    def ptr_for(slug)
      folder_ptr = head_commit.tree[folder_name]
      return nil if folder_ptr.nil?
      tree = repo.lookup(folder_ptr[:oid])
      return nil if tree.nil?
      tree[slug]
    end
  end
end
