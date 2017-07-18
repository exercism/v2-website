class My::DashboardController < MyController
  def show
    @last_solution = current_user.iterations.order('id desc').first.try(:solution)
  end
end
