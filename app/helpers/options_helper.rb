module OptionsHelper
  def as_options(collection, title_field, value_field)
    collection.map do |record|
      { text: record.send(title_field), value: record.send(value_field) }
    end
  end

  def format_options(options)
    options.each_with_object({}) do |option, hash|
      value = option[:value]
      text = option[:text]

      hash[text] = value
    end
  end

  extend self
end
