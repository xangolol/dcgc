namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
   make_users
   make_dinner_events
  end
end

def make_users
 User.create!(name: "Juriaan",
               email: "superxango@hotmail.com",
               password: "juriaan",
               password_confirmation: "juriaan")

  User.create!(name: "Emile",
               email: "emile@mail.com",
               password: "emile",
               password_confirmation: "emile")

  User.create!(name: "Rick",
               email: "rick@mail.com",
               password: "rick",
               password_confirmation: "rick")

  User.create!(name: "Mac",
               email: "mac@mail.com",
               password: "mac",
               password_confirmation: "mac")
end

def make_dinner_events
  users = User.all
  50.times do
    date = rand(-10.days..10.days).ago
    category = "dinner"
    users.sample.microposts.create!(date: date, category: category)
  end
end

def make_dinner_guests
  events = Event.all
  4.times do
    dinner = events.sample
    date = dinner.date
    category = "dinner-guest"
    name = Faker::Name.name
    dinner.user.microposts.create!(date: date, category: category, dinner_guest: name)
  end
end