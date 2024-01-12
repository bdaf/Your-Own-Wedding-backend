# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


def create_main_event_with_example_note user
    user.events.create(date: Time.now + 1.minute, name: "Created account - space for flexible notes")
    user.events.first.notes.create(name: "Example of note", body: "You can create notes like this one.")
end

User.destroy_all

user = User.create(email: "User@yow.pl", password: "Qwert123@", password_confirmation: "Qwert123@", role: "client", celebration_date: Time.now + 2.years);
support = User.create(email: "Support@yow.pl", password: "Qwert123@", password_confirmation: "Qwert123@", role: "support", celebration_date: Time.now + 2.years);

create_main_event_with_example_note user
create_main_event_with_example_note support
support.events.create(date: Time.now + 1.minute, name: "Wedding of Kowalscy")
support.events.first.notes.create(name: "Cena", body: "Mieli zapłącić 8000 zł")

20.times do 
    support.offers.create(
        title: Faker::Lorem.sentence(word_count: 3),
        description: Faker::Lorem.paragraph(sentence_count: 3),
        address: Faker::Lorem.sentence(word_count: 3),
    )
end

