class TestMessage
  include ActiveModel::AttributeAssignment

  def self.from_file(params)
    new(
      name: params[:name],
      cmd: params[:cmd],
      msg: params[:msg]
    )
  end

  attr_reader :name, :cmd, :msg

  def initialize(name:, cmd:, msg:)
    @name = name
    @cmd = cmd
    @msg = msg
  end
end
