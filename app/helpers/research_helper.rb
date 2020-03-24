module ResearchHelper
  def research_multipart_checkbox(attr, option)
    downcased_option = "#{option.gsub(/[^0-9a-z \-]/i, '').downcase.gsub(/[ -]/, '_')}"
    name = "survey[#{attr}][#{downcased_option}]"
    checked = @user_experiment.survey.dig(attr.to_s, downcased_option).to_i == 1

    label_tag(name, class: 'question-part checkbox') do
      content_tag(:div, option, class: 'option') +
      check_box_tag(name, 1, checked) +
      content_tag(:div, class: 'box') do
        icon(:check, 'selected', style: :solid, extra_classes: 'mark')
      end
    end
  end

  def research_multipart_radio(attr, option)
    value = "#{option.gsub(/[^0-9a-z \-]/i, '').downcase.gsub(/[ -]/, '_')}"
    qualified_attr = "survey[#{attr}]"
    selected = @user_experiment.survey[attr.to_s] == value

    label_tag("#{qualified_attr}_#{value}", class: 'question-part radio') do
      content_tag(:div, option, class: 'option') +
      radio_button_tag(qualified_attr, value, selected) +
      content_tag(:div, class: 'box') do
        icon(:circle, 'selected', style: :solid, extra_classes: 'mark')
      end
    end
  end

end
