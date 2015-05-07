require('spec_helper')

describe(Patron) do
  describe('#initialize') do
    it('will return the name of the patron') do
      new_patron = Patron.new({:name => "Frog", :id => nil})
      expect(new_patron.name()).to(eq("Frog"))
    end
    it('will return the id of the patron') do
      new_patron = Patron.new({:name => "Frog", :id => 1})
      expect(new_patron.id()).to(eq(1))
    end
  end
  describe(".all") do
    it('starts off with no patrons') do
      expect(Patron.all()).to(eq([]))
    end
  end
  describe("#save") do
    it("saves an patron to the database") do
      new_patron = Patron.new({:name => "Dog", :id => nil})
      new_patron.save()
      expect(Patron.all()).to(eq([new_patron]))
    end
  end
  describe(".find") do
    it("finds an patron given an id") do
      new_patron = Patron.new({:name => "Dog", :id => nil})
      new_patron.save()
      new_patron2 = Patron.new({:name => "Frog", :id => nil})
      new_patron2.save()
      expect(Patron.find(new_patron.id())).to(eq(new_patron))
    end
  end
  describe("#delete") do
    it("lets you delete an patron from the database") do
      new_patron = Patron.new({:name => "Dog", :id => nil})
      new_patron.save()
      new_patron2 = Patron.new({:name => "Frog", :id => nil})
      new_patron2.save()
      new_patron.delete()
      expect(Patron.all()).to(eq([new_patron2]))
    end
  end
  describe("#update") do
    it("lets you update patrons in the database") do
      new_patron = Patron.new({:name => "Dog", :id => nil})
      new_patron.save()
      new_patron.update({:name => "Frog"})
      expect(new_patron.name()).to(eq("Frog"))
    end
  end
end
