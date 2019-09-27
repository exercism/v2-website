module ChangelogAdmin
  module Referenceable
    def self.for(obj)
      case obj
      when Exercise
        ReferenceableExercise.new(obj)
      when Track
        ReferenceableTrack.new(obj)
      else
        NullReferenceable.new
      end
    end
  end
end
