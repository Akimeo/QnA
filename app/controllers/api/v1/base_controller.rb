class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token&.resource_owner_id)
  end

  alias current_user current_resource_owner

  def save_and_render(resource)
    if resource.save
      render json: resource
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
