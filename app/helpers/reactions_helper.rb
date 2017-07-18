module ReactionsHelper
  def reaction_icon(reaction)
    case reaction.emotion.to_sym
    when :love
      "fa-heart"
    when :wowed
      "fa-sun-o"
    when :applaud
      "fa-thumbs-up"
    end
  end
end
