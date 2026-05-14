class Loan < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :loaned_at, :due_at, presence: true
end
