class SiteContext
  attr_reader :context
  def initialize(context)
    @context = context
  end

  def layout
    case context
    when "teams"
      "teams"
    when "research"
      "research"
    else
      "application"
    end
  end

  def signed_in_path(routes)
    case context
    when "teams"
      routes.teams_dashboard_path
    when "research"
      routes.research_dashboard_path
    else
      routes.my_dashboard_path
    end
  end
end
