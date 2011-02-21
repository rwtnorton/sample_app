require 'faker'

namespace :db do

  desc 'Fill database with sample data'

  task :populate => :environment do

    # Clear database of any existing users.
    Rake::Task['db:reset'].invoke

    # Create some known sample users.
    User.create!(:name                  => 'Example User',
                 :email                 => 'user@example.com',
                 :password              => 'foobar',
                 :password_confirmation => 'foobar')
    User.create!(:name                  => 'Joy',
                 :email                 => 'joy@example.com',
                 :password              => 'penguins',
                 :password_confirmation => 'penguins')
    User.create!(:name                  => 'Gargantuan Blarg',
                 :email                 => 'blarg@example.com',
                 :password              => 'gargantuan',
                 :password_confirmation => 'gargantuan')

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

end
