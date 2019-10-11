class ChangelogEntry
  class ReferenceableExercise
    attr_reader :object

    delegate :to_global_id, to: :object

    def initialize(object)
      @object = object
    end

    def title
      "#{object.track_title} - #{object.title}"
    end

    def icon
      object.dark_icon_url
    end

    def twitter_account
      ReferenceableTrack.new(object.track).twitter_account
    end

    def as_json(*args)
      {
        id: to_global_id.to_s,
        title: title,
      }
    end

    def key
      "object_#{object.id}"
    end
  end
end
