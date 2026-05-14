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
