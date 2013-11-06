FactoryGirl.define do
  factory :user do
    name "tester"
    sequence(:email) { |n| "foo#{n}@bar.com" }
    password "secret"
    password_confirmation "secret"
  end

  factory :event do
    category "dinner"
    sequence(:date) { |n| Time.now + n.days }
    user
  end

  factory :expense do
    category "food"
    date Time.now
    user
    amount 10.50
  end

  factory :stat do
    name "test-statistic"
    value 0
  end
end