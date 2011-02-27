# == Schema Information
# Schema version: 20110222085608
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessible :name,
                  :email,
                  :password,
                  :password_confirmation
  attr_accessor   :password

  has_many :microposts,             :dependent    => :destroy
  has_many :relationships,          :foreign_key  => :follower_id,
                                    :dependent    => :destroy
  has_many :following,              :through      => :relationships,
                                    :source       => :followed
  has_many :reverse_relationships,  :foreign_key  => :followed_id,
                                    :class_name   => 'Relationship',
                                    :dependent    => :destroy
  has_many :followers,              :through      => :reverse_relationships,
                                    :source       => :follower

  email_regex = /
    \A
    [\w\+\-.]+
    @
    [a-z\d\-.]+
    \.
    [a-z]+
    \z
  /xi

  validates :name,     :presence   => true,
                       :length     => { :maximum => 50 }

  validates :email,    :presence   => true,
                       :format     => { :with => email_regex },
                       :uniqueness => { :case_sensitive => false }

  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password

  def feed
    # TODO: Preliminary.
    Micropost.where(%q{user_id = ?}, id)
  end

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email email
    return nil if user.nil?
    return nil if !user.has_password? submitted_password
    user
  end

  def self.authenticate_with_salt(user_id, cookie_salt)
    user = find_by_id user_id
    return nil if user.nil?
    user.salt == cookie_salt ? user : nil
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  private

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    # Called before the resource is saved.
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

end

=begin

Grok password authentication in fullness by example:

u = User.new(
  :name => 'Bill',
  :email => 'bill@example.com',
  :password => 'somethingclever',
  :password_confirmation => 'somethingclever',
)
# At this point, u has these attributes set to nil:
#   id
#   created_at
#   updated_at
#   salt
#   encrypted_password

u.has_password?('iliketurtles')
# nil == encrypt('iliketurtles')
# nil == secure_hash('--iliketurtles')
# nil == "e3289bd62c5622f8e6ca30d8fa441b5f53b2ca189aaf42c4fd294c2862cf5ad5"
# false

# Note that there are no side effects in calling has_password? at this point.

u.save
# Triggers our before_save hook for encrypt_password:
#   self.salt = make_salt
#     = secure_hash("2011-02-20 00:02:19 UTC--somethingclever")
#     = "b14d3a5a00b0afea69ee516d137acd3d806e6aa6b6887a31da51f020f6749a9f"
#   self.encrypted_password = encrypt('somethingclever')
#     = secure_hash('%s--%s'
#       % ["b14d3a5a00b0afea69ee516d137acd3d806e6aa6b6887a31da51f020f6749a9f",
#          'somethingclever'])
#     = "1880fd89108e81d5e601c6ce5a851be823546319e0b79b988fc71233041ad444"
#
# Next, validation hooks do their thing.
# Next, attributes id, created_at, and updated_at are populated as normal.

u.has_password?('iliketurtles')
#   encrypted_password == encrypt('iliketurtles')
#   "1880fd89108e81d5e601c6ce5a851be823546319e0b79b988fc71233041ad444" \
#     ==
#     secure_hash(
#       "b14d3a5a00b0afea69ee516d137acd3d806e6aa6b6887a31da51f020f6749a9f" +
#       "--iliketurtles")
#     ==
#     "1c5de9e7b17758ea09a270ef645c2693baa4e3579a172ff8744602f05879a3cb"
#   false

u.has_password?('somethingclever')
#   encrypted_password == encrypt('somethingclever')
#   "1880fd89108e81d5e601c6ce5a851be823546319e0b79b988fc71233041ad444" \
#     ==
#     secure_hash(
#       "b14d3a5a00b0afea69ee516d137acd3d806e6aa6b6887a31da51f020f6749a9f" +
#       "--somethingclever")
#     ==
#     "1880fd89108e81d5e601c6ce5a851be823546319e0b79b988fc71233041ad444"
#   true

=end
