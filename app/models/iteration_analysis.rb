class IterationAnalysis < ApplicationRecord
  belongs_to :iteration

  def succeeded?
    status.to_sym == :success
  end

  def handled?
    succeeded? &&
    [:approve, :approve_as_optimal, :disapprove].include?(analysis_status)
  end

  def analysis_status
    s = analysis[:status]
    s.present?? s.to_s.to_sym : nil
  end

  def analysis_comments_data
    analysis[:comments]
  end

  def built_comments
    AnalysisServices::BuildComments.new(analysis_comments_data).comments
  rescue
    []
  end

  def analysis
    (super || {}).symbolize_keys
  end
end
