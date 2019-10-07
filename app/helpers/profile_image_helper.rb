module ProfileImageHelper
  def profile_image(person)
    default_avatar = "anonymous.png"
    avatar = person.avatar_url || default_avatar

    image avatar,
      "Photo of #{person.name}",
      onerror: "this.src = '#{image_url(default_avatar)}'"
  end
end
