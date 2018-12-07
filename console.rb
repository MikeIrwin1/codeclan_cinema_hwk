require('pry')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

customer1 = Customer.new({'name' => 'Jeff Beck', 'funds' => 10})
customer2 = Customer.new({'name' => 'Joe Satriani', 'funds' => 20})
customer1.save
customer2.save
