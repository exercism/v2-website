FactoryBot.define do
  factory :maintainers_concept_exercise, class: 'Maintainers::ConceptExercise' do
    
  end

  factory :infrastructure_test_runner_version, class: 'Infrastructure::TestRunnerVersion' do
    test_runner { create :infrastructure_test_runner }
    slug { SecureRandom.uuid }
  end

  factory :infrastructure_test_runner, class: 'Infrastructure::TestRunner' do
    language_slug { "ruby" }
    timeout_ms { 2000 }
    version_slug { SecureRandom.uuid }
    num_processors { 3 }
  end

  factory :research_experiment, class: 'Research::Experiment' do
    title { "Foobar" }
    repo_url { "https://github.com/exercism/something" }
  end

  factory :research_experiment_solution, class: 'Research::ExperimentSolution' do
    user { create :user }
    experiment { create :research_experiment }
    exercise { create(:exercise, :research, slug: "ruby-1-a") }
    uuid { SecureRandom.uuid }
    git_sha { Git::ExercismRepo.current_head(track.repo_url) }
    git_slug { "ruby-1-a" }
  end

  factory :research_user_experiment, class: 'Research::UserExperiment' do
    user { create :user }
    experiment { create :research_experiment }
  end

  factory :submission_test_run do
    submission { create :submission }
    ops_status { 0 }
  end

  factory :submission do
    uuid { SecureRandom.uuid }
    solution { create :research_experiment_solution }
    filenames { ["foo", "bar"] }
  end

  factory :iteration_analysis do
    iteration { create :iteration }
    ops_status { :no_analyzer }
  end

  factory :user_email_log do
    user { create :user }
  end
  factory :solution_star do
    solution { create :solution }
    user { create :user }
  end
  factory :blog_comment do
    blog_post { create :blog_post }
    user { create :user }
    content { "foobar" }
    html { "<p>foobar</p>" }
  end

  factory :blog_post do
    uuid { SecureRandom.uuid }
    slug { "slug-#{SecureRandom.uuid}" }
    category { "category-#{SecureRandom.uuid}" }
    published_at { Time.current - 1.minute }
    title { "Some blog post" }
    author_handle { create(:user).handle }
    content_repository { "blog" }
    content_filepath { SecureRandom.uuid }

    trait :published do
      published_at { 2.weeks.ago }
    end
  end

  factory :solution_comment do
    solution { create :solution }
    user { create :user }
      content { "Hello. World!" }
      html { "<p>Hello. World!</p>" }
  end

  factory :solution_lock do
    solution { create :solution }
    user { create :user }
    locked_until { Time.current }
  end

  factory :team_invitation do
    team { create :team }
    invited_by { create :user }
    email { "someone@somewhere.com" }
  end

  factory :team_membership do
    team { create :team }
    user { create :user }
  end

  factory :team do
    name { "The best team" }
  end

  factory :team_solution do
    team { create :team }
    user { create :user }
    exercise { create :exercise }
    git_sha { SecureRandom.uuid }
    git_slug { SecureRandom.uuid }
  end

  factory :ignored_solution_mentorship do
    user { create :user }
    solution { create :solution }
  end

  factory :contributor do
    github_username { SecureRandom.uuid }
    sequence(:github_id)
    avatar_url { "asd.jpg" }
    num_contributions { 20 }
  end

  factory :testimonial do
    headline { "Love it" }
    content { "Wowowowowow!!!" }
    byline { "Nicky from the block" }
  end

  factory :iteration_file do
    iteration { create :iteration }
    filename { "foobar-#{SecureRandom.uuid}.rb"}
    file_contents { "something = :else" }
  end

  factory :maintainer do
    track { create :track }
    github_username { "iHiD" }
    name { "Jeremy Walker" }
    avatar_url { "http://website.com/somewhere.jpg" }
  end

  factory :exercise_topic do
    exercise { create :exercise }
    topic { create :topic }
  end

  factory :topic do
    slug { "foobar" }
  end

  factory :profile do
    user { create :user }
    display_name { user.name }
  end

  factory :communication_preferences do
    user { create :user }
  end

  factory :notification do
    user { create :user }
    type { :some_notification_type }
    content { "Foobar" }
    link { "http://barfoo.com" }
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

  factory :discussion_post do
    iteration { create :iteration }
    user { create :user }
    content { "Some comment here" }
    html { "<p>Some comment here</p>" }
  end

  factory :iteration do
    solution { create :solution }
  end

  factory :track do
    title { "Ruby" }
    slug { "ruby-#{SecureRandom.uuid}" }
    syntax_highlighter_language { slug }
    syntax_highligher_language { slug }
    introduction { "Master the Ruby language" }
    code_sample {%q{
      puts "Hello World"
    }}
    repo_url { "file://#{Rails.root}/test/fixtures/track" }
    median_wait_time { 30.hours }

    trait :research do
      repo_url { "file://#{Rails.root}/test/fixtures/research-track" }
    end
  end

  factory :exercise do
    track { create :track }
    uuid { SecureRandom.uuid }
    slug { "hello-world" }
    title { "Hello World" }
    core { false }
    position { 1 }

    trait :research do
      track { create(:track, :research) }
    end
  end

  factory :user do
    name { "Jeremy Walker #{SecureRandom.random_number}" }
    handle { SecureRandom.uuid }
    email { "jez.walker+#{SecureRandom.uuid}@gmail.com" }
    password { "foobar123" }
    current_sign_in_at { Time.now }
    show_v3_patience_modal { false }

    trait :mentor do
      is_mentor { true }
    end

    trait :system do
      id { User::SYSTEM_USER_ID }
    end

    trait :onboarded do
      accepted_terms_at { Date.new(2016, 12, 25) }
      accepted_privacy_policy_at { Date.new(2016, 12, 25) }
    end
  end

  factory :solution do
    user { create :user }
    exercise { create :exercise }
    git_sha { SecureRandom.uuid }
    git_slug { "hello-world" }
  end

  factory :user_track do
    user { create :user }
    track { create :track }
    independent_mode { false }
  end

  factory :repo_update do
    slug { "website-copy" }
  end

  factory :repo_update_fetch do
    repo_update { create(:repo_update) }
    host { |n| "host-#{n}" }
  end

  factory :mentor do
    track
    name { "Mentor" }
    github_username { "mentor" }
  end

  factory :changelog_entry do
    title { "Entry" }
    association :created_by, factory: :user
  end

  factory :changelog_entry_tweet do
    copy { "Hello, world!" }
    association :entry, factory: :changelog_entry
  end
end
