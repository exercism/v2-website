module ReactionsHelper
  def reaction_icon(reaction)
    case reaction.emotion.to_sym
    when :like
      "fa-thumbs-up"
    when :love
      "fa-heart"
    when :genius
      "fa-sun-o" # TODO
    end
  end
end
