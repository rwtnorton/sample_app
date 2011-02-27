require 'faker'

namespace :db do

  desc 'Fill database with sample data'

  task :populate => :environment do

    # Clear database of any existing users.
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end

end

def make_users
  # Create some known sample users.
  User.create!(:name                  => 'Example User',
               :email                 => 'user@example.com',
               :password              => 'foobar',
               :password_confirmation => 'foobar')
  User.create!(:name                  => 'Joy',
               :email                 => 'joy@example.com',
               :password              => 'penguins',
               :password_confirmation => 'penguins')
  # Blarg gets to be our sample admin.
  admin =
  User.create!(:name                  => 'Gargantuan Blarg',
               :email                 => 'blarg@example.com',
               :password              => 'gargantuan',
               :password_confirmation => 'gargantuan')
  admin.toggle!(:admin)

  # Create 97 other sample users.
  97.times do |n|
    name     = Faker::Name.name
    email    =  "user-#{n+1}@example.com"
    password = 'password'
    User.create!(:name                  => name,
                 :email                 => email,
                 :password              => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  # Create 50 microposts for each of the first six users.
  User.all(:limit => 6).each do |user|
    50.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
