class Article < ApplicationRecord
  belongs_to :user

  has_many :article_categories

  has_many :categories, through: :article_categories

  validates :title, presence: true
  validates :description, presence: true

  enum :status, { draft: 0, pending_review: 1, approved: 2, rejected: 3, published: 4 }
end