module PanelHelper
  def panel_classes_for(user)
    "panels--vertical-split" unless user.full_width_code_panes?
  end
end
