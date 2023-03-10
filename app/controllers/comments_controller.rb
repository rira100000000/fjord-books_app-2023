# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy edit update]
  before_action :correct_user, only: %i[destroy edit update]
  before_action :set_comment, only: %i[destroy edit update]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to request.referer, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to request.referer, alert: @comment.errors.full_messages
    end
  end

  def destroy
    @comment.destroy
    redirect_to request.referer, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def correct_user
    redirect_to(root_path) unless current_user.id == @commentable.comments.find(params[:id]).user_id
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end
end
