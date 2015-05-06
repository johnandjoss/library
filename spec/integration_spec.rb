require('capybara/rspec')
require('spec_helper')
require('./app')
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
end
