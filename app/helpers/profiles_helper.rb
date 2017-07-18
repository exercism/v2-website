module ProfilesHelper
  def profile_link_or_anonymous(profile)
    if profile && profile.persisted?
      link_to(@profile.name, @profile)
    else
      "Anonymous"
    end
  end

  def profile_avatar_or_default_url(profile)
    if profile && profile.persisted?
      profile.avatar_url
    else
      "" # TODO
    end
  end
end
