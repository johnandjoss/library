require('spec_helper')

describe(Author) do
  describe('#initialize') do
    it('will return the name of the author') do
      new_author = Author.new({:name => "Frog", :id => nil})
      expect(new_author.name()).to(eq("Frog"))
    end
    it('will return the id of the author') do
      new_author = Author.new({:name => "Frog", :id => 1})
      expect(new_author.id()).to(eq(1))
    end
  end
  describe(".all") do
    it('starts off with no authors') do
      expect(Author.all()).to(eq([]))
    end
  end
  describe("#save") do
    it("saves an author to the database") do
      new_author = Author.new({:name => "Dog", :id => nil})
      new_author.save()
      expect(Author.all()).to(eq([new_author]))
    end
  end
  describe(".find") do
    it("finds an author given an id") do
      new_author = Author.new({:name => "Dog", :id => nil})
      new_author.save()
      new_author2 = Author.new({:name => "Frog", :id => nil})
      new_author2.save()
      expect(Author.find(new_author.id())).to(eq(new_author))
    end
  end
  describe("#delete") do
    it("lets you delete an author from the database") do
      new_author = Author.new({:name => "Dog", :id => nil})
      new_author.save()
      new_author2 = Author.new({:name => "Frog", :id => nil})
      new_author2.save()
      new_author.delete()
      expect(Author.all()).to(eq([new_author2]))
    end
  end
  describe("#update") do
    it("lets you update authors in the database") do
      new_author = Author.new({:name => "Dog", :id => nil})
      new_author.save()
      new_author.update({:name => "Frog"})
      expect(new_author.name()).to(eq("Frog"))
    end
  end
end
