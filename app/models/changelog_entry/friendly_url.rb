class ChangelogEntry
  class FriendlyUrl < SimpleDelegator
    def to_model
      self
    end

    def to_param
      url_slug
    end

    def url
      Rails.application.routes.url_helpers.url_for(self)
    end
  end
end
