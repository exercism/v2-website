module ApplicationHelper
  def code_person_widget
    content_tag :div, id: "widget-code-person" do
      image_tag random_person_image_url
    end
  end

  def random_person_image_url
    Exercism::PeopleImagesPath / Exercism::PeopleImages.sample
  end
end
