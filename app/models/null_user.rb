class NullUser
  def handle
    "Anonymous User"
  end

  def avatar_url
    User::DEFAULT_AVATAR
  end
end
