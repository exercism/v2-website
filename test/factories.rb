FactoryGirl.define do
  factory :favourite do
    iteration { create :iteration }
  end

  factory :discussion_post do
    iteration { create :iteration }
    user { create :user }
    content "Some comment here"
  end

  factory :iteration do
    solution { create :solution }
    code "Foobar"
  end

  factory :track do
    title "Ruby"
  end

  factory :exercise do
    track { create :track }
    title "Bob"
    core false
    position 1
  end

  factory :user do
    name "Jeremy Walker"
    email { "jez.walker+#{SecureRandom.uuid}@gmail.com" }
    password "foobar123"
  end

  factory :solution do
    user { create :user }
    exercise { create :exercise }
  end

  factory :user_track do
    user { create :user }
    track { create :track }
  end
end
