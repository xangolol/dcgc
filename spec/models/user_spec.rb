require 'spec_helper'

describe User do
  let(:user) { User.new(name:"Juriaan", email: "superxango@hotmail.com", password: "secret", password_confirmation: "secret") }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it {should be_valid}

  describe "when email is not present" do
    before { user.email = " " }
    it { should_not be_valid }
  end

  describe "email wrong format" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |adress|
        user.email = adress
        expect(user).not_to be_valid
      end
    end
  end

  describe "email correct format" do
    it "should be invalid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |adress|
        user.email = adress
        expect(user).to be_valid
      end
    end
  end

  describe "duplicate email" do
    before do
      same_user = user.dup
      same_user.email = user.email.upcase
      same_user.save
    end

    it { should_not be_valid }
  end

  describe "password not present" do
    let(:user) { User.new(name:"Juriaan", email: "superxango@hotmail.com", password: " ", password_confirmation: " ") }
    it { should_not be_valid }
  end

  describe "password_confirmation not the same" do
    before { user.password_confirmation = "something different" }
    it { should_not be_valid }
  end

  describe "password length" do
    before { user.password = user.password_confirmation = "a" * 5 }
    it { should_not be_valid}
  end

  describe "check authenticate method" do
    before { user.save }
    let(:found_user) { User.find_by(email: user.email) }

    describe "valid password" do
      it { should eq found_user.authenticate(user.password) }
    end

    describe "invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
end
