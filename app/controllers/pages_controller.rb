class PagesController < ApplicationController
  before_action :redirect_if_signed_in!, only: [:index]

  PAGES = {
    "Terms and Conditions": :terms,
    "Privacy Policy": :privacy,
    "Frequently Asked Questions": :faqs,
    "Exercism's Values": :values,
    "How Exercism Works": :about,
    "Become a Mentor": :become_a_mentor,
    "Become a Maintainer": :become_a_maintainer
  }

  PAGES.each do |title, page|
    define_method page do
      markdown = Git::WebsiteContent.head.pages["#{page}.md"] || ""
      @page = page
      @title = title
      @content = ParsesMarkdown.parse(markdown.to_s)
      render action: "generic"
    end
  end

  # Landing page
  def index
    @tracks = Track.reorder("rand()").to_a
  end

  def team
    @title = "The Exercism Team"
    @maintainers_last_updated_at = Maintainer.order('updated_at DESC').limit(1).pluck(:updated_at)[0].to_i
    @maintainers = Maintainer.visible.reorder('LENGTH(bio) DESC').to_a.
                   group_by(&:github_username).map {|_, ms|
                      if ms.length == 1
                        ms[0]
                      else
                        ms.sort_by{|m|-m.bio.to_s.length}.first
                      end
                    }.sort {|a,b|
                      comp = a.active? <=> b.active?
                      comp.nil? || comp.zero?? [-1,1].sample : comp
                    }

    @contributors_last_updated_at = Contributor.order('updated_at DESC').limit(1).pluck(:updated_at)[0].to_i
    @contributors = Contributor.where.not(is_core: true).where.not(is_maintainer: true).order("num_contributions DESC").limit(40)
  end

  def contributors
    respond_to do |format|
      format.html { redirect_to team_page_path }
      format.js do
        @contributors_last_updated_at = Contributor.order('updated_at DESC').limit(1).pluck(:updated_at)[0].to_i
        @contributors = Contributor.where.not(is_core: true).where.not(is_maintainer: true).order("num_contributions DESC").offset(40)
      end
    end
  end
end
