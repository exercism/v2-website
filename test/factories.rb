FactoryGirl.define do
  factory :exercise do
    title "Bob"
  end

  factory :favourite do
    submission { create :submission }
  end

  factory :feedback do
    submission { create :submission }
  end

  factory :implementation do
    track_exercise { create :track_exercise }
  end

  factory :submission do
    user_implementation { create :user_implementation }
  end

  factory :track do
    title "Ruby"
  end
  factory :track_exercise do
    track { create :track }
    exercise { create :exercise }
  end

  factory :user do
    name "Jeremy Walker"
    email { "jez.walker+#{SecureRandom.uuid}@gmail.com" }
    password "foobar123"
  end

  factory :user_implementation do
    user { create :user }
    implementation { create :implementation }
  end

  factory :user_track do
    user { create :user }
    track { create :track }
  end
end
