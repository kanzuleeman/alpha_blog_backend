class AddStatusToArticles < ActiveRecord::Migration[6.0] # or your version
  def change
    add_column :articles, :status, :integer, default: 0, null: false
  end
end
