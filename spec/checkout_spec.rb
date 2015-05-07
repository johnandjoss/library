require('spec_helper')

describe(Checkout) do
  describe('#initialize') do
    it("returns the attributes") do
      new_checkout = Checkout.new({:book_id => 1, :patron_id => 2, :id => nil, :due_date => nil})
      expect(new_checkout.book_id()).to(eq(1))
    end
  end
end
