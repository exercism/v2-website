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
    p exercise.difficulty
    case exercise.difficulty
    when 1,2,3
      "easy"
    when 4,5,6,7
      "medium"
    when 8,9,10
      "hard"
    end
  end

end

