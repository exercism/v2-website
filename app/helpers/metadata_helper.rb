module MetadataHelper
  def metadata_title
    @metadata_title ||= format_title(metadata.try(:fetch, :title, nil))
  end

  def metadata_description
    @metadata_description ||= metadata.try(:fetch, :description, nil) || "Code Practice and Mentorship for Everyone. Level up your programming skills with 1,879 exercises across 38 languages, and insightful discussion with our dedicated team of welcoming mentors. Exercism is 100% free forever."
  end

  def metadata_image_url
    @metadata_image_url ||= metadata.try(:fetch, :image_url, nil) || "https://assets.exercism.io/social/general.png"
  end

  def metadata_url
    @metadata_url ||= request.original_url.gsub(/\/$/, "")
  end

  private

  def format_title(title)
    return "Exercism" unless title
    "#{title} | Exercism"
  end

  def metadata
    @metadata ||=
      case namespace_name
      when "admin"
        { title: "Admin" }
      when "my"
        case controller_name
        when "notifications"
          { title: "Notifications" }
        when "settings", "track_settings", "preferences"
          { title: "Settings" }
        when "starred_solutions"
          { title: "Starred solutions" }
        when "solutions"
          case action_name
          when "index"
            { title: "Completed solutions" }
          else
            { title: "#{@track.title} | #{@exercise.title}" }
          end
        when "tracks"
          case action_name
          when "index"
            { title: "Tracks" }
          when "show"
            { title: "#{@track.title} Track" }
          end
        end
      when "mentor"
        case controller_name
        when "registrations"
          { title: "Become a mentor" }
        when "solutions"
          handle = @redact_users ? "[Redacted]" : display_handle(@solution.user, @solution_user_track)
          {
            title: "#{handle} | #{@track.title}/#{@exercise.title}"
          }
        else
          { title: "Mentor Dashboard" }
        end
      else
        case controller_name
        when "blog_posts"
          case action_name
          when 'index'
            {
              title: "The Exercism Blog",
              description: "News, interviews and articles from the Exercism community.",
              image_url: "https://assets.exercism.io/social/blog.png"
            }
          else
            {
              title: @blog_post.title,
              description: blog_post_summary(@blog_post),
              image_url: @blog_post.image_url.presence || "https://assets.exercism.io/social/blog.png"
            }
          end
        when "pages"
          case action_name
          when :index
          else
            { title: @page_title }
          end
        when "solutions"
          case action_name
          when "show"
            return {} unless @solution

            exercise = @solution.exercise
            track = exercise.track
            handle = @solution.user.handle_for(track)
            {
              title: "#{handle}'s solution to #{exercise.title} on the #{track.title} track",
              description: "See how #{handle} solved the #{exercise.title} exercise on the #{track.title} track",
              image_url: track.bordered_turquoise_icon_url
            }
          end
        when "tracks"
          case action_name
          when "index"
            { title: "Language Tracks" }
          when "show"
            {
              title: "#{@track.title}",
              description: @track.introduction,
              image_url: @track.bordered_turquoise_icon_url
            }
          end
        when "exercises"
          case action_name
          when "index"
            { title: "Exercises on the #{@track.title} Track" }
          when "show"
            { title: @exercise.title }
          end
        when "registrations"
          { title: "Sign up" }
        when "sessions"
          { title: "Sign in" }
        when "passwords"
          { title: "Reset your password" }
        when "confirmations"
          { title: "Resend confirmation email" }
        when "profiles"
          case action_name
          when "show"
            { title: @user == current_user ? "My Profile" : "#{@profile.display_name}'s Profile" }
          when "index"
            { title: "Profiles" }
          end
        end
      end
  end

  def determine_description
  end

  def determine_image_url
  end
end
