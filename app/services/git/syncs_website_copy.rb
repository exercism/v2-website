class Git::SyncsWebsiteCopy
  include Mandate

  def call
    sync_mentors!
  end

  private
  attr_reader :mentor_ids

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

    mentor.tap do |mentor|
      mentor.assign_attributes(
        name: mentor_data[:name],
        avatar_url: mentor_data[:avatar_url],
        link_url: mentor_data[:link_url],
        link_text: mentor_data[:link_text],
        bio: mentor_data[:bio]
      )
      mentor.save!
    end
  end

  def delete_old_mentors!
    Mentor.where.not(id: mentor_ids).destroy_all
  end

  def repo
    @repo ||= Git::WebsiteContent.head
  end
end
