class Git::WebsiteContent < Git::RepoBase

  REPO_URL="https://github.com/exercism/website-copy"

  def self.head
    new(REPO_URL)
  end

  def initialize(repo_url, auto_fetch=false)
    super
  end

  def pages
    Pages.new(self, head_commit)
  end

  class Pages
    attr_reader :repo, :head_commit

    def initialize(repo, head_commit)
      @repo = repo
      @head_commit = head_commit
    end

    def [](slug)
      page = pages_tree[slug]
      return nil if page.nil?
      repo.read_blob(page[:oid])
    end

    def exercise_tree(slug)
      ptr = exercises_tree[slug]
      return nil if ptr.nil?
      repo.lookup(ptr[:oid])
    end

    def pages_tree
      pages_ptr = head_commit.tree['pages']
      repo.lookup(pages_ptr[:oid])
    end
  end
end
