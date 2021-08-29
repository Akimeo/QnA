class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    if current_user.author_of?(attachment.record)
      attachment.purge
    end
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment
end
