require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/book')
require('./lib/author')
require('pg')

DB = PG.connect({:dbname => "library_database"})

get('/') do
  erb(:index)
end

get('/admin') do
  @books = Book.all()
  @authors = Author.all()
  erb(:admin)
end

get('/books') do
  @books = Book.all()
  erb(:books)
end

post('/books') do
  title = params.fetch("title")
  book = Book.new({:title => title, :id => nil})
  book.save()
  @books = Book.all()
  erb(:books)
end

get('/authors') do
  @authors = Author.all()
  erb(:authors)
end

post('/authors') do
  name = params.fetch("name")
  author = Author.new({:name => name, :id => nil})
  author.save()
  @authors = Author.all()
  erb(:authors)
end

get('/books/:id') do
  id = params.fetch("id").to_i
  @book = Book.find(id)
  @authors = Author.all()
  erb(:book_info)
end

patch('/books/:id') do
  book_id = params.fetch("id").to_i
  @book = Book.find(book_id)
  author_ids = params.fetch("author_ids")
  @book.update({:author_ids => author_ids})
  @authors = Author.all()
  erb(:book_info)
end
