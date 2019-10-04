module ChangelogAdmin
  class EntriesController < BaseController
    before_action :set_entry!,
      only: [:edit, :update, :show, :publish, :unpublish, :destroy]
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
      @actions = ChangelogAdmin::ChangelogEntryAction.all
    end

    def publish
      unless AllowedToPublishEntryPolicy.allowed?(
        user: current_user,
        entry: @entry
      )
        return unauthorized!
      end

      @entry.publish!
      @entry.tweet!

      redirect_to changelog_admin_entry_path(@entry)
    end

    def unpublish
      unless AllowedToUnpublishEntryPolicy.allowed?(
        user: current_user,
        entry: @entry
      )
        return unauthorized!
      end

      @entry.unpublish!

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

    def destroy
      @entry.destroy

      redirect_to changelog_admin_entries_path
    end

    private

    def set_entry!
      @entry = ChangelogEntry.find(params[:id])
    end

    def check_if_entry_is_editable!
      return unauthorized! unless allowed_to_edit?(@entry)
    end

    def allowed_to_edit?(entry)
      AllowedToEditEntryPolicy.allowed?(user: current_user, entry: entry)
    end

    def form_params
      params.
        require(:changelog_entry_form).
        permit(:title, :details_markdown, :referenceable_gid, :info_url, :tweet_copy)
    end
  end
end
