module Temporary
  class DeleteStaleNotificationsTask
    include Mandate

    def initialize(stream: $stdout)
      @stream = stream
    end

    def call
      delete_solution_notifications!
      delete_iteration_notifications!
    end

    private
    attr_reader :stream

    def delete_solution_notifications!
      solution_ids = Solution.select(:id)

      notifications = Notification.
        where(about_type: "Solution").
        where.not(about_id: solution_ids)

      stream.puts "Deleting #{notifications.count} stale notifications about solutions"

      notifications.destroy_all
    end

    def delete_iteration_notifications!
      iteration_ids = Iteration.select(:id)

      notifications = Notification.
        where(about_type: "Iteration").
        where.not(about_id: iteration_ids)

      stream.puts "Deleting #{notifications.count} stale notifications about iterations"

      notifications.destroy_all
    end
  end
end
