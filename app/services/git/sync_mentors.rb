class Git::SyncMentors
  include Mandate

  def initialize(repo = Git::WebsiteContent.head)
    @repo = repo
  end

  def call
    sync_mentors!
  end

  private

  attr_reader :mentor_ids, :repo

  def sync_mentors!
    upsert_mentors!
    delete_old_mentors!
  end

  def upsert_mentors!
    @mentor_ids ||= repo.mentors.map do |mentor_data|
      mentor = upsert_mentor!(mentor_data)
      mentor.id
    end
  end

  def upsert_mentor!(mentor_data)
    mentor = Mentor.find_or_initialize_by(
      track: Track.find_by!(slug: mentor_data[:track]),
      github_username: mentor_data[:github_username]
    )

    github_profile = begin
                       Git::GithubProfile.for_user(mentor_data[:github_username])
                     rescue Git::GithubProfile::NotFoundError
                       Git::NullGithubProfile.new
                     end

    mentor.tap do |mentor|
      mentor.assign_attributes(
        name: mentor_data[:name] || github_profile.name,
        avatar_url: mentor_data[:avatar_url] || github_profile.avatar_url,
        link_url: mentor_data[:link_url] || github_profile.link_url,
        link_text: mentor_data[:link_text] || github_profile.link_url,
        bio: mentor_data[:bio] || github_profile.bio
      )
      mentor.save!
    end
  end

  def delete_old_mentors!
    Mentor.where.not(id: mentor_ids).destroy_all
  end
end
