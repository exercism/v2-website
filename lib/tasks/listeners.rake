namespace :exercism do
  desc 'Listens for propono messages about analyzed iterations'
  task :listen_for_analyzed_iterations => :environment do
    ListenForAnalyzedIterations.()
  end
end

