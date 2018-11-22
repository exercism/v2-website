module MentorDashboardHelper
  SECONDS_PER_DAY = 60 * 60 * 24

  def time_ago_in_words(time)
    if (DateTime.now - time.to_datetime) * SECONDS_PER_DAY < 1.day
      super(time)
    else
      number_of_days = ((Time.now - time) / SECONDS_PER_DAY).to_i
      pluralize(number_of_days, 'day')
    end
  end
end
