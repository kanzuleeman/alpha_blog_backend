class Api::V1::CategoriesController < ApplicationController
  before_action :require_login
  before_action :load_and_authorize_category, only: [:show, :edit, :update, :destroy]

  # Auto-authorize class-level actions
  before_action -> { authorize Category }, only: [:index, :new, :create]

  def index
    @categories = policy_scope(Category)
    render json: @categories
  end

  def new
    render json: {}
  end

  def create
    @category = Category.new(category_params)
    render_or_error(@category.save, @category, :created)
  end

  def edit
    render json: @category
  end

  def update
    render_or_error(@category.update(category_params), @category)
  end

  def destroy
    @category.destroy
    head :no_content
  end

  def show
    render json: @category
  end

  private

  def load_and_authorize_category
    @category = Category.find(params[:id])
    authorize @category
  end

  def category_params
    params.require(:category).permit(:name)
  end

  # Metaprogramming-like dynamic JSON responder
  def render_or_error(success, resource, success_status = :ok)
    if success
      render json: resource, status: success_status
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end
end
