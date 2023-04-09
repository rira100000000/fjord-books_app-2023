# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy edit update]
  before_action :set_comment, only: %i[destroy edit update]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_back_or_to(root_path, allow_other_host: false, notice: t('controllers.common.notice_create', name: Comment.model_name.human))
    else
      redirect_back_or_to(root_path, allow_other_host: false, alert: @comment.errors.full_messages)
    end
  end

  def destroy
    @comment.destroy
    redirect_back_or_to(root_path, allow_other_host: false, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human))
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

  def set_comment
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_path unless @comment
  end
end
