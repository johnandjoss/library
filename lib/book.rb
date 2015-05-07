class Book
  attr_reader(:id, :title)

  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id)
    @title = attributes.fetch(:title)
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  define_singleton_method(:all) do
    all_books = []
    result = DB.exec("SELECT * FROM books;")
    result.each() do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i()
      all_books.push(Book.new({:title => title, :id => id}))
    end
    all_books
  end

  define_method(:==) do |other_book|
    self.title().eql?(other_book.title()) & self.id().eql?(other_book.id())
  end

  define_singleton_method(:find) do |id|
    @id = id
    result = DB.exec("SELECT * FROM books WHERE id = #{id};")
    @title = result.first().fetch("title")
    Book.new({:title => @title, :id => @id})
  end

  define_method(:update) do |attributes|
    @title = attributes.fetch(:title, @title)
    DB.exec("UPDATE books SET title = '#{@title}' WHERE id = #{self.id()};")

    attributes.fetch(:author_ids, []).each() do |author_id|
      DB.exec("INSERT INTO books_authors (book_id, author_id) VALUES (#{self.id()}, #{author_id});")
    end
  end

  define_method(:delete) do
    DB.exec("DELETE FROM books_authors WHERE book_id = #{self.id()};")
    DB.exec("DELETE FROM books WHERE id = #{self.id()};")
  end

  define_method(:authors) do
    author_books = []
    results = DB.exec("SELECT author_id FROM books_authors WHERE book_id = #{self.id()};")
    results.each() do |result|
      author_id = result.fetch("author_id").to_i()
      author = DB.exec("SELECT * FROM authors WHERE id = #{author_id};")
      name = author.first().fetch("name")
      author_books.push(Author.new({:name => name, :id => author_id}))
    end
    author_books
  end

  define_singleton_method(:search) do |search_title|
    found_books = []
    results = DB.exec("SELECT * FROM books WHERE title LIKE '%#{search_title}%'")
    results.each() do |result|
      id = result.fetch("id").to_i()
      title = result.fetch("title")
      found_books.push(Book.new({:title => title, :id => id}))
    end
    found_books
  end
end
