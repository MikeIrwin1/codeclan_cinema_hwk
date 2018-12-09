require_relative('../db/sql_runner')
require_relative('film')
require_relative('ticket')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1,$2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    return customers.map {|customer| Customer.new(customer)}
  end

  def films()
    sql = "SELECT films.* FROM
    films INNER JOIN tickets
    ON films.id = tickets.film_id
    WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map {|film| Film.new(film)}
  end

  def purchase_ticket(screening)
    sql = "SELECT screenings.* , (SELECT films.price FROM films WHERE id = $1) FROM screenings WHERE film_id = $1"
    values = [screening.film_id]
    film_details = SqlRunner.run(sql, values)
    film_id = film_details[0]['film_id'].to_i
    film_price = film_details[0]['price'].to_i
    screening_id =film_details[0]['id'].to_i
    if screening.available > 0
      if @funds >= film_price
        @funds -= film_price
        Ticket.new({'customer_id' => @id, 'film_id' => film_id, 'screening_id' => screening_id}).save
        screening.update
      else
        return "Not enough funds!"
      end
    else
      return "There are no tickets for this screening available"
    end
  end

  def number_of_tickets()
    sql = "SELECT COUNT(customer_id) FROM tickets WHERE customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result[0]['count'].to_i
  end

end
