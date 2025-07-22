require "test_helper"

class ArticleCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article_category = article_categories(:one)
  end

  test "should get index" do
    get article_categories_url, as: :json
    assert_response :success
  end

  test "should create article_category" do
    assert_difference("ArticleCategory.count") do
      post article_categories_url, params: { article_category: { article_id: @article_category.article_id, category_id: @article_category.category_id } }, as: :json
    end

    assert_response :created
  end

  test "should show article_category" do
    get article_category_url(@article_category), as: :json
    assert_response :success
  end

  test "should update article_category" do
    patch article_category_url(@article_category), params: { article_category: { article_id: @article_category.article_id, category_id: @article_category.category_id } }, as: :json
    assert_response :success
  end

  test "should destroy article_category" do
    assert_difference("ArticleCategory.count", -1) do
      delete article_category_url(@article_category), as: :json
    end

    assert_response :no_content
  end
end
