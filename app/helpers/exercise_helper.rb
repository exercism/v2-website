module ExerciseHelper

  def exercise_length_word(exercise)
    case exercise.length
    when 1
      "short"
    when 2
      "medium"
    when 3
      "long"
    end
  end

  def exercise_difficulty_word(exercise)
    case exercise.difficulty
    when 1
      "easy"
    when 2
      "medium"
    when 3
      "hard"
    end
  end

end

