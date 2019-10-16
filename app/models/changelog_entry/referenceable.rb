class ChangelogEntry
  module Referenceable
    def self.find(id)
      return GeneralReferenceable.new if id.blank?

      self.for(GlobalID::Locator.locate(id))
    end

    def self.for(obj)
      case obj
      when Exercise
        ReferenceableExercise.new(obj)
      when Track
        ReferenceableTrack.new(obj)
      else
        GeneralReferenceable.new
      end
    end
  end
end
