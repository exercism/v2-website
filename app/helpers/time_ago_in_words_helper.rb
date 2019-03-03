module TimeAgoInWordsHelper
  SECONDS_PER_DAY = 60 * 60 * 24

  def time_ago_in_words(time)
    # Use the default if < 1.day
    return super if (DateTime.now - time.to_datetime) * SECONDS_PER_DAY < 1.day

    # Use the default if >= 1.year
    return super if (DateTime.now - time.to_datetime) * SECONDS_PER_DAY >= 1.year

    number_of_days = ((Time.now - time) / SECONDS_PER_DAY).to_i
    pluralize(number_of_days, 'day')
  end
end
