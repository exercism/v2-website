module SelectizeHelpers
  def select_option(option, id:)
    within("select##{id}+.selectize-control") do
      first('div.selectize-input').click
      find('div.option', :text => option).click
    end
  end
end
