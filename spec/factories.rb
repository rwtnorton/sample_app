# By using the symbol :user, we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                   'Quux the Great'
  user.email                  'quux@example.com'
  user.password               'Quuxfoobar'
  user.password_confirmation  'Quuxfoobar'
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content 'Foo bar'
  micropost.association :user
end
