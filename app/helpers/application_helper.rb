module ApplicationHelper
  def async_stylesheet_link_tag(url, options = {})
    content_for :async_css do
      stylesheet_link_tag(url, options)
    end

    stylesheet_link_tag(
      url,
      {
        rel: "preload",
        as: "style"
      }.merge(options)
    )
  end

  def code_person_widget
    content_tag :div, id: "widget-code-person" do
      image_tag random_person_image_url,
        alt: 'Programming person with notebook'
    end
  end

  def random_person_image_url
    (Exercism::PeopleImagesPath / Exercism::PeopleImages.sample).to_s
  end

  def hotjar_enabled?
    return false unless Rails.env.production?
    return true  if current_user.nil?
    return false if current_user.admin? || current_user.test_user?
    true
  end

  def url_with_protocol(url)
    return url if url.starts_with? "https://"
    if url.starts_with? "http://"
      url.sub("http://", "https://")
    else
      "https://#{url}"
    end
  end
end
