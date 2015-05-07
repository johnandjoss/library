class Patron
  attr_reader(:id, :name)

  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  define_singleton_method(:all) do
    all_patrons = []
    result = DB.exec("SELECT * FROM patrons;")
    result.each() do |patron|
      name = patron.fetch("name")
      id = patron.fetch("id").to_i()
      all_patrons.push(Patron.new({:name => name, :id => id}))
    end
    all_patrons
  end

  define_method(:==) do |other_patron|
    self.name().eql?(other_patron.name()) & self.id().eql?(other_patron.id())
  end

  define_singleton_method(:find) do |id|
    @id = id
    result = DB.exec("SELECT * FROM patrons WHERE id = #{id};")
    @name = result.first().fetch("name")
    Patron.new({:name => @name, :id => @id})
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE patrons SET name = '#{@name}' WHERE id = #{self.id()};")

    attributes.fetch(:book_ids, []).each() do |book_id|
      due_date = Time.now() + (2*7*24*60*60)
      new_checkout = Checkout.new({:id => nil, :book_id => book_id, :patron_id => @id, :due_date => due_date})
      new_checkout.save()
    end
  end

  # define_method(:check_out) do
  #   book_patrons = []
  #   results = DB.exec("SELECT * FROM checkouts WHERE patron_id = #{self.id()};")
  #   results.each() do |result|
  #     book_id = result.fetch("book_id").to_i()
  #     book = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
  #     title = book.first().fetch("title")
  #     book_patrons.push(Book.new({:title => title, :id => book_id}))
  #   end
  #   book_patrons
  # end

  define_method(:check_out) do
    patron_checkouts = []
    results = DB.exec("SELECT * FROM checkouts WHERE patron_id = #{self.id()};")
    results.each() do |result|
      book_id = result.fetch("book_id").to_i
      patron_id = result.fetch("patron_id").to_i
      due_date = result.fetch('due_date')
      id = result.fetch("id").to_i
      patron_checkouts.push(Checkout.new({:book_id => book_id, :patron_id => patron_id, :id => id, :due_date => due_date}))
    end
    patron_checkouts
  end

  define_singleton_method(:search) do |search_name|
    found_patrons = []
    results = DB.exec("SELECT * FROM patrons WHERE name LIKE '%#{search_name}%'")
    results.each() do |result|
      id = result.fetch("id").to_i()
      name = result.fetch("name")
      found_patrons.push(Patron.new({:name => name, :id => id}))
    end
    found_patrons
  end

  define_method(:delete) do
    DB.exec("DELETE FROM checkouts WHERE patron_id = #{self.id()};")
    DB.exec("DELETE FROM patrons WHERE id = #{self.id()};")
  end
end
