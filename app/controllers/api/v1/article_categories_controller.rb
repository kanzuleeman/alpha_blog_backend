class ArticleCategoriesController < ApplicationController
  before_action :set_article_category, only: %i[show update destroy]

  # GET /article_categories
  def index
    render json: ArticleCategory.all
  end

  # GET /article_categories/:id
  def show
    render json: @article_category
  end

  # POST /article_categories
  def create
    article_category = ArticleCategory.new(article_category_params)

    if article_category.save
      render json: article_category, status: :created
    else
      render_unprocessable(article_category)
    end
  end

  # PATCH/PUT /article_categories/:id
  def update
    if @article_category.update(article_category_params)
      render json: @article_category
    else
      render_unprocessable(@article_category)
    end
  end

  # DELETE /article_categories/:id
  def destroy
    @article_category.destroy
    head :no_content
  end

  private

  def set_article_category
    @article_category = ArticleCategory.find(params[:id])
  end

  def article_category_params
    params.require(:article_category).permit(:article_id, :category_id)
  end

  def render_unprocessable(record)
    render json: record.errors, status: :unprocessable_entity
  end
end
