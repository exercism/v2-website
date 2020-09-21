class Admin::Data::ExperimentsController < AdminController
  before_action :restrict_to_admins!

  def show
    zip_path = ExportExperimentData.(@solutions)
    send_file(zip_path)
  end
end


