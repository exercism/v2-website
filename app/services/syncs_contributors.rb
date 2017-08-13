class SyncsContributors
  def self.sync!(*args)
    new(*args).sync!
  end

  attr_reader :filepath
  def initialize(filepath)
    @filepath = filepath
  end

  def sync!
    contributors = JSON.parse(File.read(filepath), symbolize_names: true)
    contributors.each do |_, contributor_data|
      data = {
        avatar_url: contributor_data[:avatar],
        num_contributions: contributor_data[:repositories].sum{|r|r[:contributions]},
      }
      username = contributor_data[:username]
      contributor = Contributor.find_or_create_by!(github_username: username) do |c|
        c.assign_attributes(data)
      end
      contributor.update!(data)
    end

    Contributor.where(github_username: Maintainer.select(:github_username)).update_all(is_maintainer: true)
    Contributor.where(github_username: %w{
      kytrinyx iHiD ccare nicolechalmers
    }).update_all(is_core: true)
  end
end
