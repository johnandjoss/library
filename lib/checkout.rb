class Checkout
  attr_reader(:id, :book_id, :patron_id, :due_date)

  define_method(:initialize) do |attributes|
    @book_id = attributes.fetch(:book_id)
    @patron_id = attributes.fetch(:patron_id)
    @due_date = attributes.fetch(:due_date)
    @id = attributes.fetch(:id)
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO checkouts (book_id, patron_id, due_date) VALUES (#{@book_id}, #{@patron_id}, '#{@due_date}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  define_singleton_method(:all) do
    all_checkouts = []
    result = DB.exec("SELECT * FROM checkouts;")
    result.each() do |checkout|
      book_id = checkout.fetch("book_id")
      patron_id = checkout.fetch("patron_id")
      id = checkout.fetch("id").to_i()
      due_date = checkout.fetch("due_date")
      all_checkouts.push(Checkout.new({:book_id => book_id, :patron_id => patron_id, :id => id, :due_date => due_date}))
    end
    all_checkouts
  end

  define_singleton_method(:find_by_patron) do |patron_id|
    patron_checkouts = []
    results = DB.exec("SELECT * FROM checkouts WHERE patron_id = #{patron_id};")
    results.each() do |checkout|
      book_id = checkout.fetch("book_id")
      patron_id = checkout.fetch("patron_id")
      id = checkout.fetch("id").to_i()
      due_date = checkout.fetch("due_date")
      patron_checkouts.push(Checkout.new({:book_id => book_id, :patron_id => patron_id, :id => id, :due_date => due_date}))
    end
    patron_checkouts
  end

  define_singleton_method(:over_due) do
    overdue_items = []
    todays_date = Time.now()
    results = DB.exec("SELECT * FROM checkouts WHERE due_date < '#{todays_date}'")
    results.each() do |checkout|
      book_id = checkout.fetch("book_id")
      patron_id = checkout.fetch("patron_id")
      id = checkout.fetch("id").to_i()
      due_date = checkout.fetch("due_date")
      overdue_items.push(Checkout.new({:book_id => book_id, :patron_id => patron_id, :id => id, :due_date => due_date}))
    end
    overdue_items
  end

end
