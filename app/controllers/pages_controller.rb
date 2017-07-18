class PagesController < ApplicationController
  before_action :redirect_if_signed_in!, only: [:index]

  def donate
  end
end
