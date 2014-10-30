# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Cat.transaction do
  30.times do 
    Cat.create(name: Faker::Internet.user_name, color: "black", sex: "M",
    birth_date: Faker::Date.backward(10000), description: Faker::Hacker.say_something_smart)
  end
end

CatRentalRequest.transaction do
  cat_ids = Cat.all.pluck(:id)
  250.times do
    CatRentalRequest.create(cat_id: cat_ids.sample, start_date: Faker::Date.between(Date.today, Date.new(2015,1,1)), end_date: Faker::Date.between(Date.new(2015,11,11), Date.new(2016,1,1)))
  end
end
#
# User.transaction do
#
#   User.create(user_name: Faker::Name.name)
#
# end