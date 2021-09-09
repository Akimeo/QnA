class AwardsController < ApplicationController
  load_and_authorize_resource

  def index
    @awards = current_user&.awards
  end
end
