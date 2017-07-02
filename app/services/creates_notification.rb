class CreatesNotification
  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :user, :content, :link, :about
  def initialize(user, content, link, about: nil)
    @user = user
    @about = about
    @content = content
    @link = link
  end

  def create!
    Notification.create!(
      user: user,
      about: about,
      content: content,
      link: link
    )
  end
end
