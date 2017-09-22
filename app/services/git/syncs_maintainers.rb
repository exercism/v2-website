class Git::SyncsMaintainers
  DEFAULT_ALUMNUS_STRING = "alumnus"

  def self.sync!(track, maintainer_config)
    new(track, maintainer_config).sync!
  end

  attr_reader :track, :maintainer_config

  def initialize(track, maintainer_config)
    @track = track
    @maintainer_config = maintainer_config
  end

  def sync!
    if maintainer_config.nil?
      Rails.logger.warn "Skipping due to nil maintainer config"
      return
    end
    @maintainer_ids = []
    maintainers.each do |m|
      upsert_maintainer(m)
    end
    remove_old_maintainers
  end

  private

  def maintainers
    maintainer_config.fetch(:maintainers, []) || []
  end

  def upsert_maintainer(m)
    gh_user = m[:github_username]
    name = m[:name]
    show_on_website = m[:show_on_website] || false

    return unless gh_user.present? && show_on_website.present?
    return unless show_on_website

    alumnus = m[:alumnus]

    alumnus = DEFAULT_ALUMNUS_STRING if alumnus == true

    gh_profile = Git::GithubProfile.for_user(gh_user)

    link_url = m.fetch(:link_url, gh_profile.link_url)
    link_text = m.fetch(:link_text, link_url)

    maintainer_data = {
      alumnus: alumnus,
      name: (m[:name] || gh_profile.name),
      bio: (m[:bio] || gh_profile.bio),
      avatar_url: (m[:avatar_url] || gh_profile.avatar_url),
      link_url: link_url,
      link_text: link_text
    }
    maintainer = Maintainer.find_or_create_by!(track: track, github_username: gh_user) do |mm|
      mm.assign_attributes(maintainer_data)
    end
    maintainer.update!(maintainer_data)

    @maintainer_ids << maintainer.id
  end

  def remove_old_maintainers
    Maintainer.where(track: track).where.not(id: @maintainer_ids).delete_all
  end

end
