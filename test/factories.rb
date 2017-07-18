FactoryGirl.define do
  factory :exercise_topic do
    exercise { create :exercise }
    topic { create :topic }
  end

  factory :topic do
    slug "foobar"
  end

  factory :profile do
    user { create :user }
    name "Jo Bloggs"
    slug { SecureRandom.uuid }
  end

  factory :communication_preferences do
    user { create :user }
  end

  factory :notification do
    user { create :user }
    type :some_notification_type
    content "Foobar"
    link "http://barfoo.com"
  end

  factory :track_mentorship do
    user { create :user }
    track { create :track }
  end

  factory :auth_token do
    user { create :user }
    token { SecureRandom.uuid }
  end

  factory :solution_mentorship do
    user { create :user }
    solution { create :solution }
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
    git_sha { SecureRandom.uuid }
  end

  factory :user_track do
    user { create :user }
    track { create :track }
  end
end
