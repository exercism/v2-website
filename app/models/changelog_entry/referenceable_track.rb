class ChangelogEntry
  class ReferenceableTrack
    attr_reader :object

    delegate :to_global_id, to: :object

    def initialize(object)
      @object = object
    end

    def title
      object.title
    end

    def icon
      object.bordered_green_icon_url
    end

    def twitter_account
      TwitterAccount.find(object.slug.to_sym)
    end

    def as_json(*args)
      {
        id: to_global_id.to_s,
        title: title,
      }
    end

    def key
      "track_#{object.id}"
    end
  end
end
