module PrismJS
  class Plugin
    def self.all
      [
        new(
          name: :line_numbers,
          stylesheet: "#{PrismJS.cdn}/plugins/line-numbers/prism-line-numbers.css",
          javascript: "#{PrismJS.cdn}/plugins/line-numbers/prism-line-numbers.js",
        ),
        new(
          name: :line_highlight,
          stylesheet: "#{PrismJS.cdn}/plugins/line-highlight/prism-line-highlight.css",
          javascript: "#{PrismJS.cdn}/plugins/line-highlight/prism-line-highlight.js",
        ),
        new(
          name: :autoloader,
          javascript: "#{PrismJS.cdn}/plugins/autoloader/prism-autoloader.js",
          stylesheet: nil,
          params: {
            "data-autoloader-path" => "#{PrismJS.cdn}/components"
          }
        )
      ]
    end

    def self.stylesheets
      all.select { |plugin| plugin.stylesheet.present? }
    end

    attr_reader :name, :stylesheet, :javascript, :params

    def initialize(name:, stylesheet:, javascript:, params: {})
      @name = name
      @stylesheet = stylesheet
      @javascript = javascript
      @params = params
    end
  end
end
