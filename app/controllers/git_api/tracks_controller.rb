module GitAPI
  class TracksController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_track

    layout false

    def open_creation_issues
      issues = fetch_issues(%w(type/new-exercise status/help-wanted), %w(OPEN))
      render json: issues
    end

    def num_creation_issues
      issues = fetch_issues(%w(type/new-exercise), %w(OPEN CLOSED))
      render json: issues.length
    end

    def open_improve_issues
      issues = fetch_issues(%w(type/improve-exercise status/help-wanted), %w(OPEN))
      render json: issues
    end

    private

    def fetch_issues(filter_labels, states)
      client = Octokit::Client.new(access_token: Rails.application.secrets.exercism_bot_token)
      response = client.post '/graphql', { query: query(states) }.to_json
      response.data.repository.issues.edges.map do |issue|
          {
            number: issue.node.number,
            title: issue.node.title,
            body: issue.node.body,
            url: issue.node.url,
            updatedAt: issue.node.updatedAt,
            labels: issue.node.labels.edges.map{|label| label.node.name }
          }
        end
        .select{|issue| filter_labels.all?{|filter_label| issue[:labels].include?(filter_label)}}
        .sort_by{|issue|issue[:title]}
    end

    def query(states)
      %Q{
        { 
          repository(name: "v3", owner: "exercism") {
            id
            issues(
              first: 100
              states: [#{states.join(',')}]
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
