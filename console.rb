require('pry')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

Customer.delete_all
Film.delete_all

customer1 = Customer.new({'name' => 'Jeff Beck', 'funds' => 10})
customer2 = Customer.new({'name' => 'Joe Satriani', 'funds' => 20})
customer1.save
customer2.save

film1 = Film.new({'title' => 'Iron Man', 'price' => 3})
film1.save
film2 = Film.new({'title' => 'Blade Runner', 'price' => 2})
film2.save


binding.pry
nil
