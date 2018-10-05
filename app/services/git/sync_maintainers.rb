class Git::SyncMaintainers
  include Mandate

  DEFAULT_ALUMNUS_STRING = "alumnus"

  initialize_with :track, :maintainer_config

  def call
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

    alumnus = alumnus_string(m[:alumnus])

    gh_profile = Git::GithubProfile.for_user(gh_user)
    user_id = User.find_by(provider: "github", uid: gh_profile.user.id).try(:id) if gh_profile.try(:user_present?)

    link_url = m.fetch(:link_url, gh_profile.link_url)
    link_text = m.fetch(:link_text, link_url)

    maintainer_data = {
      alumnus: alumnus,
      name: (m[:name] || gh_profile.name),
      bio: (m[:bio] || gh_profile.bio),
      avatar_url: (m[:avatar_url] || gh_profile.avatar_url),
      link_url: link_url,
      link_text: link_text,
      user_id: user_id
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

  def alumnus_string(alumnus)
    case alumnus
    when true
      DEFAULT_ALUMNUS_STRING
    when false
       nil
    else
      alumnus
    end
  end
end
