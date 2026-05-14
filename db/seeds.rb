# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "hackme"
  u.password_confirmation = "hackme"
  u.member_profile_attributes = { name: "Admin" }
end
admin.add_role :admin unless admin.has_role?(:admin)

librarian = User.find_or_create_by!(email: "librarian@example.com") do |u|
  u.password = "hackme"
  u.password_confirmation = "hackme"
  u.member_profile_attributes = { name: "Librarian" }
end
librarian.add_role :librarian unless librarian.has_role?(:librarian)

User.find_or_create_by!(email: "user@example.com") do |u|
  u.password = "hackme"
  u.password_confirmation = "hackme"
  u.member_profile_attributes = { name: "User" }
end

os_tag = Tag.find_or_create_by!(name: "Operating System")
os_books = [
  { title: "Modern Operating Systems", author: "Andrew S. Tanenbaum" },
  { title: "Operating System Concepts", author: "Abraham Silberschatz" },
  { title: "The Design of the UNIX Operating System", author: "Maurice J. Bach" },
  { title: "Operating Systems: Three Easy Pieces", author: "Remzi Arpaci-Dusseau" },
  { title: "Linux Kernel Development", author: "Robert Love" },
  { title: "Windows Internals", author: "Mark Russinovich" },
  { title: "The Art of Unix Programming", author: "Eric S. Raymond" },
  { title: "Operating Systems: Internals and Design Principles", author: "William Stallings" },
  { title: "Unix Network Programming", author: "W. Richard Stevens" },
  { title: "Real-Time Systems Design and Analysis", author: "Phillip A. Laplante" }
]
os_books.each do |data|
  author = Author.find_or_create_by!(name: data[:author])
  book = Book.create!(
    name: data[:title],
    author: author
  )
  BookTag.create!(book: book, tag: os_tag)
end
