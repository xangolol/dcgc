FactoryGirl.define do
  factory :user do
    name "tester"
    email "foo@bar.com"
    password "secret"
    password_confirmation "secret"
  end
end