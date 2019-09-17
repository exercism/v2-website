class CreateSystemDiscussionPost
  include Mandate

  initialize_with :message, :iteration

  def call
    content = { i18n_message: message }.to_json
    interpolated_message = I18n.t(message)

    DiscussionPost.create!(
      iteration: iteration,
      user: User.system_user,
      content: content,
      html: ParseMarkdown.(interpolated_message)
    )
  end
end
