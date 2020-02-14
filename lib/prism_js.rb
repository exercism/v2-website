require "prism_js/theme"
require "prism_js/plugin"
require "prism_js/component"

module PrismJS
  mattr_accessor :cdn

  def self.configure
    yield(self)
  end
end
