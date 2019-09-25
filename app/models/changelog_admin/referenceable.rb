module ChangelogAdmin
  module Referenceable
    def self.for(obj)
      case obj
      when Exercise
        ReferenceableExercise.new(obj)
      else
        obj
      end
    end
  end
end
