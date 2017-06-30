FactoryGirl.define do
  factory :auth_token do
    user { create :user }
    token { SecureRandom.uuid }
  end

  factory :mentor_review do
    user { create :user }
    mentor { create :user }
    solution { create :solution }
    rating 5
  end

  factory :favourite do
    iteration { create :iteration }
  end

  factory :discussion_post do
    iteration { create :iteration }
    user { create :user }
    content "Some comment here"
    html "<p>Some comment here</p>"
  end

  factory :iteration do
    solution { create :solution }
    code "Foobar"
  end

  factory :track do
    title "Ruby"
    slug { "ruby-#{SecureRandom.uuid}" }
  end

  factory :exercise do
    track { create :track }
    uuid { SecureRandom.uuid }
    slug { "bob-#{SecureRandom.uuid}" }
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
