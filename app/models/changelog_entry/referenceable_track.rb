class ChangelogEntry
  class ReferenceableTrack
    attr_reader :track

    delegate :to_global_id, to: :track
    delegate :tweet, to: :twitter_account

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
  end
end
