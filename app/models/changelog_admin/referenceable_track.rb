module ChangelogAdmin
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
  end
end
