require 'octokit'

module GitAPI
  class TracksController < ApplicationController
    skip_before_action :verify_authenticity_token

    layout false

    def creation_issues
      p params[:id]

      client = Octokit::Client.new(:access_token => Rails.application.secrets.exercism_bot_token)
      query = %Q{
        { 
          repository(name: "v3", owner: "exercism") {
            id
            issues(
              first: 100
              states: [OPEN]
              filterBy: { labels: ["track/#{params[:id]}"] }
            ) {
              edges {
                node {
                  number
                  title
                  body
                  url
                  updatedAt
                  labels(first: 20) {
                    edges {
                      node {
                        name
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      response = client.post '/graphql', { query: query }.to_json
      issues = response.data.repository.issues.edges.map do |issue|
          {
            :number => issue.node.number,
            :title => issue.node.title,
            :body => issue.node.body,
            :url => issue.node.url,
            :updatedAt => issue.node.updatedAt,
            :labels => issue.node.labels.edges.map { |label| label.node.name }
          }
        end.select { |issue| issue[:labels].include?('type/new-exercise') }  

      render json: issues
    end
  end
end
