module AnalysisServices
  class BuildComments
    include Mandate

    initialize_with :comments_data

    def call
      return nil unless comments_data.size > 0

      intro + comments
    end

    private
    def comments
      comments_data.map { |cd| BuildComment.(cd) }.join("\n\n---\n\n")
    end

    def intro
      text = if comments_data.size == 1
          "Our analyzer detected that this point might be helpful for you."
        else
          "Our analyzer detected that these points might be helpful for you."
        end

      text + "\n\n---\n\n"
    end
  end
end
