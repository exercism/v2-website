module SelectizeHelpers
  def select_option(option, selector:)
    within("select#{selector}+.selectize-control") do
      first('div.selectize-input').click
      find('div.option', text: option, exact_text: true).click
    end
  end
end
