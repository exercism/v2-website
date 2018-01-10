class MyController < ApplicationController
  before_action :authenticate_user!
end
