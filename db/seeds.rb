# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all

user = User.create(email: "User@yow.pl", password: "12341234", password_confirmation: "12341234", role: "user");
support = User.create(email: "Support@yow.pl", password: "12341234", password_confirmation: "12341234", role: "support");
admin = User.create(email: "Admin@yow.pl", password: "12341234", password_confirmation: "12341234", role: "admin");

# 20.times do 
#     support.offers.create(
#         title: Faker::Lorem.sentence(word_count: 3),
#         description: Faker::Lorem.paragraph(sentence_count: 3),
#         address: Faker::Lorem.sentence(word_count: 3),
#     )
# end
