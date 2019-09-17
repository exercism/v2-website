module ChangelogAdmin
  class EntriesController < BaseController
    def new
      @form = ChangelogEntryForm.new
    end

    def create
      @form = ChangelogEntryForm.new(form_params)

      @form.save

      redirect_to changelog_admin_entry_path(@form.entry)
    end

    def show
      @entry = ChangelogEntry.find(params[:id])
    end

    private

    def form_params
      params.
        require(:changelog_entry_form).
        permit(:title, :details_markdown, :referenceable_gid, :info_url).
        merge(created_by: current_user)
    end
  end
end
