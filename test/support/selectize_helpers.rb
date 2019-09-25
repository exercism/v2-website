module SelectizeHelpers
  def select_option(option, selector:)
    within("select#{selector}+.selectize-control") do
      first('div.selectize-input').click
      find('div.option', exact_text: option).click
    end
  end
end
