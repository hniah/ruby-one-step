class CommentsController < ApplicationController
  def index
    @project = get_project
    @comments = @project.comment_threads.order('created_at desc').page(params[:page]).per(2)
  end

  def create
    @comment_hash = params[:comment]
    @obj = @comment_hash[:commentable_type].constantize.find(@comment_hash[:commentable_id])
    @comment = Comment.build_from(@obj, current_user.id, @comment_hash[:body])
    if @comment.save
      render partial: 'comments/comment', locals: {comment: @comment}, layout: false, status: :created
    else
      render js: "alert('error saving comment');"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render json: @comment, status: :ok
    else
      render js: "alert('error deleting comment');"
    end
  end

  def project_id
    params.require(:project_id)
  end

  def get_project
    Project.find(project_id)
  end
end
