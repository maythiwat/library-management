class Book < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  validates :name, presence: true

  belongs_to :author

  has_many :book_tags
  has_many :tags, through: :book_tags
end
