require('capybara/rspec')
require('./app')
require('spec_helper')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe("The library path", {:type => :feature}) do
  it("visits the admin page") do
    visit('/')
    click_link('Admin')
    expect(page).to have_content("Library Administration")
  end

  it("adds a new book") do
    visit('/books')
    fill_in('title', :with => "Frog")
    click_button('Add book')
    expect(page).to have_content("Frog")
  end

  it("adds a new author") do
    visit('/authors')
    fill_in('name', :with => "Dog")
    click_button('Add author')
    expect(page).to have_content("Dog")
  end

  it("add author to individual book") do
    visit('/books')
    fill_in('title', :with => "Frog")
    click_button('Add book')
    visit('/authors')
    fill_in('name', :with => "Dog")
    click_button('Add author')
    visit('/admin')
    click_link('Frog')
    page.check('Dog')
    click_button('Add authors')
    expect(page).to have_content('Dog')
  end

  it("add book to individual author") do
    visit('/authors')
    fill_in('name', :with => "Bob")
    click_button('Add author')
    visit('/books')
    fill_in('title', :with => 'Bobs book')
    click_button('Add book')
    visit('/admin')
    click_link('Bob')
    page.check('Bobs book')
    click_button('Add books')
    expect(page).to have_content("Bobs book")
  end

  it("deletes a book") do
    visit('/books')
    fill_in('title', :with => "Frog")
    click_button('Add book')
    click_link("Frog")
    click_button("Delete Book")
    visit('/admin')
    fill_in('search_term', :with => "Frog")
    click_button("Search")
    expect(page).to have_content("There are no books here yet!")
  end

  it("deletes an author") do
    visit('/authors')
    fill_in('name', :with => "Bob")
    click_button('Add author')
    click_link("Bob")
    click_button("Delete Author")
    visit('/admin')
    fill_in('search_term', :with => "Bob")
    click_button("Search")
    expect(page).to have_content("There are no authors here yet!")
  end

  it("searches for a book or author") do
    visit('/authors')
    fill_in('name', :with => "Bob")
    click_button('Add author')
    visit('/books')
    fill_in('title', :with => 'Bobs book')
    click_button('Add book')
    visit('/admin')
    fill_in('search_term', :with => "Bob")
    click_button("Search")
    expect(page).to have_content("Bob")
    expect(page).to have_content("Bobs book")
  end

  it("adds a book to a patron") do
    visit('/books')
    fill_in('title', :with => 'Bobs book')
    click_button('Add book')
    visit('/')
    click_link('Library Members')
    fill_in('name', :with => "Kevin")
    click_button('Add New Member')
    click_link('Kevin')
    page.check('Bobs book')
    click_button('Checkout Books')
    expect(page).to have_content('Bobs book')
  end
end
