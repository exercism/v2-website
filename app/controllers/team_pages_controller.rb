class TeamPagesController < ApplicationController
  def show
  end

  def maintainers
    @maintainers_last_updated_at = Maintainer.order('updated_at DESC').limit(1).pluck(:updated_at)[0].to_i
    @maintainers = Maintainer.visible.reorder('LENGTH(bio) DESC').
                                      page(@page).
                                      group(:github_username).
                                      per(40)
  end

  def mentors
    @page = params[:page]
    @mentors_last_updated_at = Mentor.order('updated_at DESC').limit(1).pluck(:updated_at)[0].to_i
    @mentors = Mentor.reorder('LENGTH(bio) DESC').
                      page(@page).
                      group(:github_username).
                      per(40)
  end

  def contributors
    @last_updated_at = Contributor.order('updated_at DESC').limit(1).pluck(:updated_at)[0].to_i
    @contributors = Contributor.where.not(is_core: true).
                                where.not(is_maintainer: true).
                                order("num_contributions DESC").
                                page(params[:page]).
                                per(40)
  end

end
