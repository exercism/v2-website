module ContributorImageHelper
  def contributor_image(contributor)
    default_avatar = "anonymous.png"
    avatar = contributor.avatar_url || default_avatar

    image avatar,
      "Photo of #{contributor.name}",
      onerror: "this.src = '#{image_url(default_avatar)}'"
  end
end
