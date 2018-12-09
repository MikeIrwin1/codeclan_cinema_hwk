require_relative('../db/sql_runner')
require_relative('customer')
require_relative('ticket')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return films.map {|film| Film.new(film)}
  end

  def customers()
    sql = "SELECT customers.* FROM
    customers INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE tickets.film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map{|customer| Customer.new(customer)}
  end

  def number_of_customers()
    sql = "SELECT COUNT(film_id) FROM tickets WHERE film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result[0]['count'].to_i
  end

  def popular_time()
    sql = "SELECT screening_id, COUNT(*)
    FROM tickets
    WHERE tickets.film_id = $1
    GROUP BY tickets.screening_id
    ORDER BY tickets.screening_id"
    values = [@id]
    screenings_count_hash = SqlRunner.run(sql, values)
    screenings_array = screenings_count_hash.map {|screenings| screenings.values.first}
    most_viewed_id = [screenings_array.first.to_i]
    sql2 = "SELECT * FROM screenings WHERE id =$1"
    show_time = SqlRunner.run(sql2, most_viewed_id).first
    return Screening.new(show_time)
  end

end
