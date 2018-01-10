module TeamsHelper
  def teams_header
    selected = case controller_name
      when "memberships"
        :memberships
      when "my_solutions"
        :my_solutions
      when "solutions"
        :solutions
      end
    render "teams/header", team: @team, selected: selected
  end
end
