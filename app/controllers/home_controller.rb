class HomeController < ApplicationController
  def index
    @total_books = Book.count
    @available_books = Book.all.count(&:available?)
    @total_authors = Author.count
    @total_members = MemberProfile.count
    @recent_books = Book.order(created_at: :desc).includes(:author, :tags).limit(4)
  end
end
