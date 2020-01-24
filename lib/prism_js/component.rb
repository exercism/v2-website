module PrismJS
  class Component
    def self.all
      [
        new(
          name: :core,
          javascript: "#{PrismJS.cdn}/components/prism-core.js"
        )
      ]
    end

    attr_reader :javascript

    def initialize(name:, javascript:)
      @name = name
      @javascript = javascript
    end
  end
end
