ruby = Track.create!(title: "Ruby")
bob = Exercise.create!(title: "Ruby")
ihid = User.create!(name: "Jeremy Walker", email: "jeremy@thalamus.ai", password: 'password')

ruby_bob = TrackExercise.create!(track: ruby, exercise: bob)
ruby_bob_implementation = Implementation.create!(track_exercise: ruby_bob)

ihid_ruby = UserTrack.create!(user: ihid, track: ruby)
ihid_ruby_bob = UserImplementation.create!(user: ihid, implementation: ruby_bob_implementation)
ihid_ruby_bob_submission_1 = Submission.create!(user_implementation: ihid_ruby_bob)


