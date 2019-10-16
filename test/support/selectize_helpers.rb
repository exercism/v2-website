module SelectizeHelpers
  def fill_in_option(selector, with:)
    within("select#{selector}+.selectize-control") do
      within(".selectize-input") do
        find("input").fill_in(with: with)
      end
    end
  end
  def select_option(option, selector:)
    within("select#{selector}+.selectize-control") do
      first('div.selectize-input').click
      find('div.option', exact_text: option).click
    end
  end
end
