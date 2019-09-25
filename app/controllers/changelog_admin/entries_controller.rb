module ChangelogAdmin
  class EntriesController < BaseController
    def index
      @entries = ChangelogEntry.all
    end

    def new
      @form = ChangelogEntryForm.new
    end

    def create
      @form = ChangelogEntryForm.new(form_params)

      if @form.valid?
        @form.save

        redirect_to changelog_admin_entry_path(@form.entry)
      else
        render :new
      end
    end

    def show
      @entry = ChangelogEntry.find(params[:id])
    end

    def publish
      @entry = ChangelogEntry.find(params[:id])

      @entry.publish!

      redirect_to changelog_admin_entry_path(@entry)
    end

    def edit
      @entry = ChangelogEntry.find(params[:id])
      @form = ChangelogEntryForm.from_entry(@entry)
    end

    def update
      @entry = ChangelogEntry.find(params[:id])
      @form = ChangelogEntryForm.new(form_params.merge(id: @entry.id))

      @form.save

      redirect_to changelog_admin_entry_path(@entry)
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
