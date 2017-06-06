ruby = Track.create!(title: "Ruby")
python = Track.create!(title: "Python")
cpp = Track.create!(title: "C++")

bob = Specification.create!(title: "Bob")
fish = Specification.create!(title: "Fish")
cat = Specification.create!(title: "Cat")
mouse = Specification.create!(title: "Mouse")

ruby_bob = Exercise.create!(track: ruby, specification: bob, core: true, position: 1)
ruby_bob_implementation = Implementation.create!(exercise: ruby_bob)

Implementation.create!(exercise: Exercise.create!(track: ruby, specification: fish, core: true, position: 2))
Implementation.create!(exercise: Exercise.create!(track: ruby, specification: cat, core: false, position: 1))
Implementation.create!(exercise: Exercise.create!(track: ruby, specification: mouse, core: false, position: 2))

ihid = User.create!(name: "Jeremy Walker", email: "jeremy@thalamus.ai", password: 'password')

ihid_ruby = UserTrack.create!(user: ihid, track: ruby)
ihid_ruby_bob = Solution.create!(user: ihid, implementation: ruby_bob_implementation)
ihid_ruby_bob_iteration_1 = Iteration.create!(solution: ihid_ruby_bob)
