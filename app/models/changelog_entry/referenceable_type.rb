class ChangelogEntry
  class ReferenceableType < SimpleDelegator
    def all
      super.map { |obj| ChangelogEntry::Referenceable.for(obj) }
    end
  end
end
