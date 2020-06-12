module GitAPI
  class TracksController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_track

    layout false

    def creation_issues
      issues = fetch_issues('type/new-exercise')
      render json: issues
    end

    def improve_issues
      issues = fetch_issues('type/improve-exercise')
      render json: issues
    end

    private

    def fetch_issues(filter_label)
      client = Octokit::Client.new(access_token: Rails.application.secrets.exercism_bot_token)
      response = client.post '/graphql', { query: query }.to_json
      response.data.repository.issues.edges.map do |issue|
          {
            number: issue.node.number,
            title: issue.node.title,
            body: issue.node.body,
            url: issue.node.url,
            updatedAt: issue.node.updatedAt,
            labels: issue.node.labels.edges.map { |label| label.node.name }
          }
        end
        .select { |issue| issue[:labels].include?(filter_label) }
    end

    def query
      %Q{
        { 
          repository(name: "v3", owner: "exercism") {
            id
            issues(
              first: 100
              states: [#{state}]
              filterBy: { labels: ["track/#{@track.slug}"] }
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
    end

    private

    def set_track
      @track = Track.find_by_slug(params[:id])
      render_error(:track_not_found) unless @track
    end

    def render_error(type)
      p "Error: #{type}"
      render json: {
        error: { type: type }
      }, status: 400

    def state
      case params[:state]
      when "open"
        "OPEN"
      when "closed"
        "CLOSED"
      when "all"
        "OPEN,CLOSED"
      else
        "OPEN"
      end
    end
  end
end
