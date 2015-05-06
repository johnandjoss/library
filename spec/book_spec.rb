require('spec_helper')

describe(Book) do
  describe('#initialize') do
    it('will return the title of the book') do
      new_book = Book.new({:title => "Frog", :id => nil})
      expect(new_book.title()).to(eq("Frog"))
    end
    it('will return the id of the book') do
      new_book = Book.new({:title => "Frog", :id => 1})
      expect(new_book.id()).to(eq(1))
    end
  end
  describe(".all") do
    it('starts off with no books') do
      expect(Book.all()).to(eq([]))
    end
  end
  describe("#save") do
    it("saves a book to the database") do
      new_book = Book.new({:title => "Dog", :id => nil})
      new_book.save()
      expect(Book.all()).to(eq([new_book]))
    end
  end
  describe(".find") do
    it("finds a book given an id") do
      new_book = Book.new({:title => "Dog", :id => nil})
      new_book.save()
      new_book2 = Book.new({:title => "Frog", :id => nil})
      new_book2.save()
      expect(Book.find(new_book.id())).to(eq(new_book))
    end
  end
  describe("#delete") do
    it("lets you delete a book from the database") do
      new_book = Book.new({:title => "Dog", :id => nil})
      new_book.save()
      new_book2 = Book.new({:title => "Frog", :id => nil})
      new_book2.save()
      new_book.delete()
      expect(Book.all()).to(eq([new_book2]))
    end
  end
  describe("#update") do
    it("lets you update books in the database") do
      new_book = Book.new({:title => "Dog", :id => nil})
      new_book.save()
      new_book.update({:title => "Frog"})
      expect(new_book.title()).to(eq("Frog"))
    end
  end
  describe("#authors") do
    it("creates an array of authors associated with a specific book") do
      new_book = Book.new({:title => "Dog", :id => nil})
      new_book.save()
      new_author = Author.new({:name => "fred", :id => nil})
      new_author.save()
      new_author2 = Author.new({:name => "fred", :id => nil})
      new_author2.save()
      new_book.update({:author_ids => [new_author.id(), new_author2.id()]})
      expect(new_book.authors()).to(eq([new_author, new_author2]))
    end
  end
end
