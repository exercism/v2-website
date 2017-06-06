FactoryGirl.define do
  factory :specification do
    title "Bob"
  end

  factory :favourite do
    iteration { create :iteration }
  end

  factory :feedback do
    iteration { create :iteration }
  end

  factory :implementation do
    exercise { create :exercise }
  end

  factory :iteration do
    solution { create :solution }
  end

  factory :track do
    title "Ruby"
  end

  factory :exercise do
    track { create :track }
    specification { create :specification }
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
    implementation { create :implementation }
  end

  factory :user_track do
    user { create :user }
    track { create :track }
  end
end
