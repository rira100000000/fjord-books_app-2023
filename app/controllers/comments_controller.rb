# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create]

  def create
    @comment = @commentable.comments.build(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to request.referer, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        format.html { redirect_to request.referer, alert: @comment.errors.full_messages }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
