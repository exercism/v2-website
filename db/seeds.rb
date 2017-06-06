ruby = Track.create!(title: "Ruby")
python = Track.create!(title: "Python")
bob = Specification.create!(title: "Bob")
ihid = User.create!(name: "Jeremy Walker", email: "jeremy@thalamus.ai", password: 'password')

ruby_bob = Exercise.create!(track: ruby, specification: bob)
ruby_bob_implementation = Implementation.create!(exercise: ruby_bob)

ihid_ruby = UserTrack.create!(user: ihid, track: ruby)
ihid_ruby_bob = Solution.create!(user: ihid, implementation: ruby_bob_implementation)
ihid_ruby_bob_iteration_1 = Iteration.create!(solution: ihid_ruby_bob)


