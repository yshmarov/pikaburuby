class PostsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index, :top, :fresh]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :favorite, :unfavorite]

  def index
    #@posts = Post.all
    redirect_to fresh_posts_path
  end
  
  def top
    @posts = Post.all.order(cached_votes_score: :desc)
    render 'index'
  end
  
  def fresh
    @posts = Post.all.order(created_at: :desc)
    render 'index'
  end

  def show
  end

  #def favorite
  #  @post.upvote_from current_user
  #  respond_to do |format|
  #    format.js
  #  end 
  #end
  
  #def unfavorite
  #  @post.downvote_by current_user
  #  respond_to do |format|
  #   format.js
  #  end 
  #end

  def like
    #if current_user.voted_on? @post
    if current_user.voted_up_on? @post
      @post.downvote_by current_user
    elsif current_user.voted_down_on? @post
      @post.upvote_by current_user
    else #not voted
      @post.upvote_by current_user
    end
    respond_to do |format|
     format.js
    end 
  end

  def new
    @post = Post.new
  end

  def edit
    if @post.user_id == current_user.id
      #OK
    else
      redirect_to root_path, notice: 'You are not authorized!'
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @post.user_id == current_user.id
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: 'У вас нет прав!'
    end
  end

  def destroy
    if @post.user_id == current_user.id
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, notice: 'You are not authorized!'
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, tag_ids: [])
    end
end
