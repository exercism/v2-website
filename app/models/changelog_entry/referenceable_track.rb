class ChangelogEntry
  class ReferenceableTrack
    attr_reader :track

    delegate :to_global_id, to: :track

    def initialize(track)
      @track = track
    end

    def title
      track.title
    end

    def icon
      track.bordered_green_icon_url
    end

    def twitter_account
      TwitterAccount.find(track.slug.to_sym)
    end

    def as_json(*args)
      {
        id: to_global_id.to_s,
        title: title,
      }
    end

    def key
      "track_#{track.id}"
    end

    def object
      track
    end
  end
end
