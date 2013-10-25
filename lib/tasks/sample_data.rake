namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_dinner_events
    make_dinner_guests
    make_expenses
  end
end

def make_users
 User.create!(name: "Juriaan",
               email: "superxango@hotmail.com",
               password: "juriaan",
               password_confirmation: "juriaan")

  User.create!(name: "Emile",
               email: "emile@mail.com",
               password: "password",
               password_confirmation: "password")

  User.create!(name: "Rick",
               email: "rick@mail.com",
               password: "password",
               password_confirmation: "password")

  User.create!(name: "Mac",
               email: "mac@mail.com",
               password: "password",
               password_confirmation: "password")
end

def make_dinner_events
  users = User.all
  100.times do
    date = pick_random_dinner_date(users)
    category = "dinner"
    user = pick_random_user(users, date)
    PaperTrail.whodunnit = user.id
    user.events.create!(date: date, category: category)
  end
end

def make_dinner_guests
  events = Event.all
  10.times do
    dinner = events.sample
    date = dinner.date
    category = "dinner-guest"
    name = Faker::Name.name
    PaperTrail.whodunnit = dinner.user.id
    dinner.user.events.create!(date: date, category: category, dinner_guest: name)
  end
end

def make_expenses
  users = User.all
  30.days.ago.to_date.upto(30.days.from_now.to_date) do |date| 
    if date.day.even?
      category = "food"
      amount = rand(8.0..30.0)
      user = users.sample
      PaperTrail.whodunnit = user.id
      user.expenses.create(date: date, category: category, amount: amount)

      #sometimes we also have some common goods bought
      if [true, false].sample 
        category = "common-goods"
        amount = rand(5.0..15.0)
        user = users.sample
        PaperTrail.whodunnit = user.id
        user.expenses.create(date: date, category: category, amount: amount)
      end
    end
  end
end

def pick_random_user(users, date)
  user = users.sample
  if user.joins_dinner?(date.strftime("%Y-%m-%d")) 
    pick_random_user(users, date)
  else 
    return user
  end
end

def pick_random_dinner_date(users)
  date = rand(-30.days..30.days).ago

  size = Event.where("date = ? AND category = ?", date.strftime("%Y-%m-%d"), "dinner").size

  if size > 3
    pick_random_dinner_date(users)
  else
    date
  end
end