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
      find('div.selectize-input').click

      unless find('div.selectize-dropdown')
        find('div.selectize-input').click
      end

      find('div.option', text: option).click
    end
  end
end
