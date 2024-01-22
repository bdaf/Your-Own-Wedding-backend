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
provider = Provider.new(address: "Białystok", phone_number: "997997997")
organizer = Organizer.new(celebration_date: Time.now + 2.years)
user = User.create(email: "OrganizerUser@yow.pl", password: "Qwert123@", password_confirmation: "Qwert123@", role: "organizer", organizer: organizer);
providerUser = User.create(email: "ProviderUser@yow.pl", password: "Qwert123@", password_confirmation: "Qwert123@", role: "provider", provider: provider);

create_main_event_with_example_note user
create_main_event_with_example_note providerUser
providerUser.events.create(date: Time.now + 1.minute, name: "Wedding of Kowalscy")
providerUser.events.first.notes.create(name: "Cena", body: "Mieli zapłącić 8000 zł")

20.times do 
    providerUser.provider.offers.create(
        title: Faker::Lorem.sentence(word_count: 3),
        description: Faker::Lorem.paragraph(sentence_count: 30),
        address: Faker::Lorem.sentence(word_count: 3),
        prize: Faker::Number.decimal(l_digits: 4, r_digits: 2),
        category: [:other, :music, :venue, :camera].sample,
    )
end

