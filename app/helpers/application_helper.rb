module ApplicationHelper
  def code_person_widget
    content_tag :div, id: "widget-code-person" do
      image_tag random_person_image_url
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
end
