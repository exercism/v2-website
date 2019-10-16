class ChangelogEntry
  class GeneralReferenceable
    def icon
      "https://via.placeholder.com/150"
    end

    def title
      "General"
    end

    def to_global_id
      nil
    end

    def twitter_account
      TwitterAccount.find(:main)
    end

    def key
      nil
    end

    def object
      nil
    end
  end
end
