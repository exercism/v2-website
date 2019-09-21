namespace :exercism do
  desc 'Listens for propono messages about analyzed iterations'
  task :listen_for_analyzed_iterations => :environment do
    ListenForAnalyzedIterations.()
  end

  desc 'Listens for propono messages about tested submissions'
  task :listen_for_tested_submissions => :environment do
    ListenForTestedSubmissions.()
  end
end
