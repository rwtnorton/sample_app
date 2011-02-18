require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => 'Example User', :email => 'user@example.com' }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ''))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name_user = User.new(@attr.merge(:name => 'a'*51))
    long_name_user.should_not be_valid
  end

  it "should accept valid emails" do
    emails = %w{ user@foo.com THE_USER@foo.bar.org first.last@foo.jp }
    emails.each do |email|
      valid_email_user = User.new(@attr.merge(:email => email))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid emails" do
    emails = %w{ user@foo,com user_at_foo.org example.user@foo. }
    emails.each do |email|
      invalid_email_user = User.new(@attr.merge(:email => email))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate emails" do
    User.create! @attr
    duplicate_email_user = User.new @attr
    duplicate_email_user.should_not be_valid
  end

  it "should reject emails identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create! @attr.merge :email => upcased_email
    duplicate_email_user = User.new @attr
    duplicate_email_user.should_not be_valid
  end

end
