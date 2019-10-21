module ChangelogAdmin
  class ReferenceablesController < BaseController
    COMPOUND_SEARCH_REGEX = /(?<track>.*) - (?<exercise>.*)/

    def search
      results = if matches = params[:query].match(COMPOUND_SEARCH_REGEX)
                  compound_search(matches[:track], matches[:exercise])
                else
                  simple_search(params[:query])
                end

      render json: results.map { |obj| ChangelogEntry::Referenceable.for(obj) }
    end

    private

    def compound_search(track, exercise)
      Exercise.
        eager_load(:track).
        where(tracks: { title: track }).
        where("exercises.title LIKE ?", "#{exercise}%").
        order(:title)
    end

    def simple_search(query)
      [
        Track.where("title LIKE ?", "#{query}%"),
        Exercise.where("title LIKE ?", "#{query}%"),
        Exercise.eager_load(:track).where("tracks.title LIKE ?", "#{query}%")
      ].flatten
    end
  end
end
