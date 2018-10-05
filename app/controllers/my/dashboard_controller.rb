class My::DashboardController < MyController
  def show
    return redirect_to [:my, :tracks]
  end
end
