module ChangelogAdmin
  class ReferenceableType < SimpleDelegator
    def all
      super.map { |obj| ChangelogAdmin::Referenceable.for(obj) }
    end
  end
end
