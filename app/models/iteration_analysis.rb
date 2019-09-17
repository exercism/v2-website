class IterationAnalysis < ApplicationRecord
  belongs_to :iteration

  def handled?
    ops_status.to_sym == :success &&
    [:approve, :approve_as_optimal, :disapprove].include?(analysis_status)
  end

  def analysis_status
    super.try(&:to_sym)
  end

  def analysis_comments_data
    analysis[:comments]
  end

  def built_comments
    return [] unless analysis_comments_data.present?

    analysis_comments_data.map { |comment_data|
      begin
        AnalysisServices::BuildComment.(comment_data)
      rescue
        nil
      end
    }.compact
  end

  def analysis
    (super || {}).symbolize_keys
  end
end
