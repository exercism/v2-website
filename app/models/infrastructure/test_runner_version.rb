class Infrastructure::TestRunnerVersion < ApplicationRecord
  belongs_to :test_runner

  enum status: [:pending, :building, :built, :deploying, :deployed, :tested, :live]
end
