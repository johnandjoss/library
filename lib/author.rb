class Author
  attr_reader(:id, :name)

  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  define_singleton_method(:all) do
    all_authors = []
    result = DB.exec("SELECT * FROM authors;")
    result.each() do |author|
      name = author.fetch("name")
      id = author.fetch("id").to_i()
      all_authors.push(Author.new({:name => name, :id => id}))
    end
    all_authors
  end

  define_method(:==) do |other_author|
    self.name().eql?(other_author.name()) & self.id().eql?(other_author.id())
  end

  define_singleton_method(:find) do |id|
    @id = id
    result = DB.exec("SELECT * FROM authors WHERE id = #{id};")
    @name = result.first().fetch("name")
    Author.new({:name => @name, :id => @id})
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{self.id()};")

    attributes.fetch(:book_ids, []).each() do |book_id|
      DB.exec("INSERT INTO books_authors (book_id, author_id) VALUES ( #{book_id}, #{self.id()});")
    end
  end

  define_method(:delete) do
    DB.exec("DELETE FROM books_authors WHERE author_id = #{self.id()};")
    DB.exec("DELETE FROM authors WHERE id = #{self.id()};")
  end
end
