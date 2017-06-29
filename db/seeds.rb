ruby = Track.create!(title: "Ruby")
python = Track.create!(title: "Python")
cpp = Track.create!(title: "C++")

bob = Exercise.create!(track: ruby, title: "Bob", core: true, position: 1)
fish = Exercise.create!(track: ruby, title: "Fish", core: true, position: 2)
cat = Exercise.create!(track: ruby, title: "Cat", core: false, position: 1, unlocked_by: bob)
mouse = Exercise.create!(track: ruby, title: "Mouse", core: false, position: 2, unlocked_by: fish)

ihid = User.create!(name: "Jeremy Walker", email: "jeremy@thalamus.ai", password: 'password')
kytrinyx = User.create!(name: "Kytrinyx", email: "kytrinyx@thalamus.ai", password: 'password')

ihid_ruby = UserTrack.create!(user: ihid, track: ruby)
ihid_bob = Solution.create!(user: ihid, exercise: bob, status: :iterating, approved_by: kytrinyx)
ihid_bob_iteration_1 = Iteration.create!(solution: ihid_bob, code: %q{
class Bob
  RESPONSES = {
    silent:   'Fine. Be that way.',
    asking:   'Sure.',
    shouting: 'Woah, chill out!',
    default:  'Whatever.'
  }

  def hey(text)
    tone = ToneDeterminer.determine_tone(text)
    RESPONSES[tone]
  end
end

class ToneDeterminer
  class << self
    def determine_tone(text)
      new(text).tone
    end
  end

  ADJECTIVES = %w{silent shouting asking}
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def tone
    ADJECTIVES.each do |adjective|
      return adjective.to_sym if send("#{adjective}?")
    end
    :default
  end

  private
    def silent?
      text.to_s.empty?
    end

    def asking?
      text.end_with?("?")
    end

    def shouting?
      text.upcase == text
    end
end
%}.strip)

iteration1_discussion1 = ihid_bob_iteration_1.discussion_posts.create!(user: kytrinyx, content: "", html: %q{I really like the adjectives, and the predicate methods that they're used for. I like how the responder allows you to save the text as an instance variable without running into thread-safety issues.\nI feel like the meta-programming is making it hard to see which responses go with which tones, even though you've named the methods in a very expressive way.})

iteration1_discussion2_content = %q{Great feedback. Thank you.\n\nSo I was split between two ways of doing this. \n1) Either method pairs with adjectives (which I did), \n2) Some sort of data structure (e.g. a hash might look like)\n```{\n->{text.to_s.empty?} => 'Fine. Be that way.',\n->{text.upcase == text} => "Woah, chill out!",\n->{text.end_with?("?")} => "Sure."\n}```\n\nThe main reason for the structure would be to link the response to the tone more clearly, which I entirely agree is unclear with the first option. However, I think the hash is just too ugly, and it seemed to be getting overkill to make a whole new structure, or a multi-dimensional array. I also don't think this idea scales for more complex methods.\n\nA better option might be to have the "respond_to_silent" method, do a check and respond, then return true/false. This would link them better. However, I like the ability have separation between what counts as shouting, and how to respond, for single responsibility of methods.\n\nSplitting the pairs into classes would work well (Shout/Silent/Asking classes with a checker/responder). Feels again a little overkill though.\n\nVery happy to hear any suggestions :)}
iteration1_discussion2 = ihid_bob_iteration_1.discussion_posts.create!(user: ihid, content: iteration1_discussion2_content, html: ParsesMarkdown.parse(iteration1_discussion2_content))

#Iteration.create!(solution: ihid_bob, code: "Another go")
