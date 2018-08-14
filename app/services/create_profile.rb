class CreateProfile
  initialize_with :user, :display_name

  def call
    Profile.create(
      user: user,
      display_name: display_name
    )
  end
end
