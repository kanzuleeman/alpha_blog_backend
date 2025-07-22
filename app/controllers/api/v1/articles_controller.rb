class Api::V1::ArticlesController < ApplicationController

  ROLE_ARTICLE_SCOPES = {
    "writer" => ->(user) { user.articles },
    "editor" => ->(_)    { Article.where(status: "pending_review") },
    "admin"  => ->(_)    { Article.where(status: "approved") }
  }.freeze

  ARTICLE_STATUS_MAP = {
    "submit"        => "pending_review",
    "approve"       => "approved",
    "reject"        => "rejected",
    "publish"       => "published"
  }.freeze
  
  before_action :require_login, except: [:published]
  before_action :set_article, only: [:show, :update, :destroy] + ARTICLE_STATUS_MAP.keys.map(&:to_sym)

  

  def index
    @articles = ROLE_ARTICLE_SCOPES.fetch(current_user.role, ->(_) { Article.none }).call(current_user)

    render json: @articles.includes(:categories).map { |article| serialized_article(article) }
  end

  def show
    authorize @article
    render json: serialized_article(@article)
  end

  def create
    @article = current_user.articles.new(article_params)
    authorize @article

    if @article.save
      render json: serialized_article(@article), status: :created
    else
      render_errors
    end
  end

  def update
    authorize @article

    @article.category_ids = params[:category_ids] if params[:category_ids].present?

    if @article.update(article_params.except(:user_id))
      render json: serialized_article(@article)
    else
      render_errors
    end
  end

  def destroy
    authorize @article
    @article.destroy
    head :no_content
  end

  # Dynamically define submit/approve/reject/publish actions
  ARTICLE_STATUS_MAP.each do |action, status|
    define_method(action) do
      with_authorization(@article, "#{action}?") do
        update_article_status(status)
      end
    end
  end

  # Define actions: pending_review and approved
  %w[pending_review approved].each do |status_name|
    define_method(status_name) do
      with_authorization(Article, "#{status_name}?") do
        render json: Article.where(status: status_name)
      end
    end
  end

  def published
    render json: Article.published.includes(:categories).as_json(include: :categories)
  end

  private

  def set_article
    @article = Article.find_by(id: params[:id])
    render json: { error: "Not found" }, status: :not_found unless @article
  end

  def article_params
    params.require(:article).permit(:title, :description, :status, category_ids: [])
  end

  def require_login
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  def render_errors
    render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
  end

  def serialized_article(article)
    article.as_json(include: :categories).merge(
      can_edit: ArticlePolicy.new(current_user, article).update?,
      can_delete: ArticlePolicy.new(current_user, article).destroy?
    )
  end

  def with_authorization(record, policy_method)
    authorize record, policy_method.to_sym
    yield
  end

  def update_article_status(status)
    if @article.update(status: status)
      render json: serialized_article(@article)
    else
      render_errors
    end
  end
end
