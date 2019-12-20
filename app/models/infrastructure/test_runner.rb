class Infrastructure::TestRunner < ApplicationRecord
  has_many :versions, class_name: "TestRunnerVersion"
end
