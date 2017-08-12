module MetadataHelper
  def metadata_title
    @metadata_title ||= metadata.try(:fetch, :title, nil) || "Exercism"
  end

  def metadata_description
    @metadata_description ||= metadata.try(:fetch, :description, nil) || "Code Practice and Mentorship for Everyone. Level up your programming skills with 1,879 exercises across 38 languages, and insightful discussion with our dedicated team of welcoming mentors. Exercism is 100% free forever."
  end

  def metadata_image_url
    @metadata_image_url ||= metadata.try(:fetch, :image_url, nil) || image_url("logo.png")
  end

  def metadata_url
    @metadata_url ||= request.original_url.gsub(/\/$/, "")
  end

  private
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
            {
              title: @title
            }
          end
        when "tracks"
          case action_name
          when "show"
            {
              title: "#{@track.title} on Exercism",
              description: @track.introduction,
              image_url: @track.bordered_turquoise_icon_url
            }
          end
        end
      end
  end

  def determine_description
  end

  def determine_image_url
  end
end
