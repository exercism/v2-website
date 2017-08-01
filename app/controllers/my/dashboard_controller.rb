class My::DashboardController < MyController
  def show
    return redirect_to [:my, :tracks]
    @last_solution = current_user.iterations.order('id desc').first.try(:solution)
  end
end
