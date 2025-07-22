class AddCascadeDeleteToArticleCategories < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :article_categories, :articles

    add_foreign_key :article_categories, :articles, on_delete: :cascade
  end
end
