module TeamsHelper
  def teams_header
    selected = 
      case controller_name
        when "memberships",
             "invitations"
          :memberships
        when "my_solutions"
          :my_solutions
        when "solutions"
          :solutions
        else
          case action_name
          when 'edit'
            :edit
          else
            :home
          end
        end
    render "teams/header", team: @team, selected: selected
  end
end
