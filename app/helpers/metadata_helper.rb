module MetadataHelper
  def metadata_title
    @metadata_title ||= format_title(metadata.try(:fetch, :title, nil))
  end

  def metadata_description
    @metadata_description ||= metadata.try(:fetch, :description, nil) || "Code Practice and Mentorship for Everyone. Level up your programming skills with 1,879 exercises across 38 languages, and insightful discussion with our dedicated team of welcoming mentors. Exercism is 100% free forever."
  end

  def metadata_image_url
    @metadata_image_url ||= metadata.try(:fetch, :image_url, nil) || image_url("icon.png")
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
      when "my"
        nil
      else
        case controller_name
        when "pages"
          case action_name
          when :index
          else
            { title: @page_title }
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
        end
      end
  end

  def determine_description
  end

  def determine_image_url
  end
end
