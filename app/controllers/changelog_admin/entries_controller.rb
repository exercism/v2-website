module ChangelogAdmin
  class EntriesController < BaseController
    before_action :check_if_entry_is_editable!, only: [:edit, :update]

    def index
      @entries = ChangelogEntry.all
    end

    def new
      @form = ChangelogEntryForm.new
    end

    def create
      @form = ChangelogEntryForm.new(form_params.merge(created_by: current_user))

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
      @form = ChangelogEntryForm.from_entry(@entry)
    end

    def update
      @form = ChangelogEntryForm.from_entry(@entry)

      @form.assign_attributes(form_params)

      if @form.valid?
        @form.save

        redirect_to changelog_admin_entry_path(@entry)
      else
        render :edit
      end
    end

    private

    def check_if_entry_is_editable!
      @entry = ChangelogEntry.find(params[:id])

      unless AllowedToEditEntryPolicy.allowed?(
        user: current_user,
        entry: @entry
      )
        return unauthorized!
      end
    end

    def form_params
      params.
        require(:changelog_entry_form).
        permit(:title, :details_markdown, :referenceable_gid, :info_url)
    end
  end
end
