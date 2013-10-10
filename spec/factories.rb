FactoryGirl.define do
  factory :user do
    name "tester"
    email "foo@bar.com"
    password "secret"
    password_confirmation "secret"
  end

  factory :event do
    category "dinner"
    sequence(:date) { |n| Time.now + n.days }
    user
  end
end