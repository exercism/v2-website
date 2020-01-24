module PrismJS
  class Theme
    def self.all
      [
        new(
          name: :dark,
          stylesheet: "#{PrismJS.cdn}/themes/prism-okaidia.min.css",
        ),
        new(
          name: :light,
          stylesheet: "#{PrismJS.cdn}/themes/prism.min.css",
        ),
      ]
    end

    attr_reader :name, :stylesheet

    def initialize(name:, stylesheet:)
      @name = name
      @stylesheet = stylesheet
    end

    def disabled?(user)
      user.theme != name
    end
  end
end
