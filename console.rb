require('pry')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

Customer.delete_all
Film.delete_all

customer1 = Customer.new({'name' => 'Jeff Beck', 'funds' => 10})
customer2 = Customer.new({'name' => 'Joe Satriani', 'funds' => 20})
customer3 = Customer.new({'name' => 'Michael Irwin', 'funds' => 50})
customer1.save
customer2.save
customer3.save

film1 = Film.new({'title' => 'Iron Man', 'price' => 3})
film1.save
film2 = Film.new({'title' => 'Blade Runner', 'price' => 2})
film2.save

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film2.id})
ticket3 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film2.id})
ticket1.save
ticket2.save
ticket3.save

customer3.purchase_ticket(film1)
binding.pry
nil
