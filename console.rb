require('pry')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

Screening.delete_all
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

film1_screening1 = Screening.new({'show_time' => '20:30', 'film_id' => film1.id, 'available' => 2})
film2_screening1 = Screening.new({'show_time' => '19:00', 'film_id' => film2.id, 'available' => 5})
film1_screening2 = Screening.new({'show_time' => '19:00', 'film_id' => film1.id, 'available' => 4})
film1_screening1.save
film2_screening1.save
film1_screening2.save

customer1.purchase_ticket(film1_screening1)

film1.popular_time()
binding.pry
nil
