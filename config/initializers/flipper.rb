Flipper.configure do |config|
  config.default do
    adapter = if Rails.env.test?
                Flipper::Adapters::Memory.new
              else
                Flipper::Adapters::ActiveRecord.new
              end

    Flipper.new(adapter)
  end
end

Flipper.register(:admins) do |actor|
  actor.respond_to?(:admin?) && actor.admin?
end
