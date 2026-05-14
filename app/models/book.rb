class Book < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  validates :name, presence: true

  belongs_to :author

  has_many :book_tags
  has_many :tags, through: :book_tags

  has_many :loans
  has_many :users, through: :loans

  def available?
    loans.where(returned_at: nil).empty?
  end
end
