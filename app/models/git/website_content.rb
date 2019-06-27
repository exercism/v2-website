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

  def licences
    FolderReader.new(self, head_commit, 'licences')
  end

  def walkthrough
    FolderReader.new(self, head_commit, 'walkthrough')["index.html"]
  end

  def mentor_notes_for(track_slug, exercise_slug)
    ptr = head_commit.tree["tracks"]
    tree = repo.lookup(ptr[:oid])
    target = "#{track_slug}/exercises/#{exercise_slug}/"
    tree.walk_blobs do |root, file|
      next unless root == target
      next unless file[:name] == "mentoring.md"
      file_blob = repo.lookup(file[:oid])
      return file_blob.text
    end

    nil
  end

  def automated_comment_for(code)
    ptr = head_commit.tree["automated-comments"]
    tree = repo.lookup(ptr[:oid])
    path = "#{code.split(".")[0...-1].join("/")}/"
    filename = "#{code.split(".").last}.md"

    tree.walk_blobs do |root, file|
      next unless root == path
      next unless file[:name] == filename
      file_blob = repo.lookup(file[:oid])
      return file_blob.text
    end

    nil
  end


  def mentors
    ptr = head_commit.tree["mentors"]
    tree = repo.lookup(ptr[:oid])

    mentors = []

    tree.walk_blobs do |root, file|
      if File.extname(file[:name]) == ".json"
        track_slug = root.chomp("/")
        mentor_jsons = read_json_blob(file[:oid])

        Array.wrap(mentor_jsons).each do |json|
          mentors << json.merge(track: track_slug)
        end
      end
    end

    mentors
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
