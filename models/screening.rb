require_relative('../db/sql_runner')
require_relative('ticket')

class Screening

  attr_reader :id
  attr_accessor :film_id, :show_time, :available

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @show_time = options['show_time']
    @available = options['available'].to_i
  end

  def save()
    sql = "INSERT INTO screenings (film_id, show_time, available) VALUES ($1,$2, $3) RETURNING id"
    values = [@film_id, @show_time, @available]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def update()
    @available -=1
    sql = "UPDATE screenings SET (film_id, show_time, available) = ($1, $2, $3) WHERE id = $4"
    values = [@film_id, @show_time, @available, @id]
    SqlRunner.run(sql, values)
  end

  def available()
    return @available
  end

end
