require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
  end  #describe Home Page

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end    #describe Help page

  it "should have the right links on the layout" do
    visit root_path
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Home"
    page.should have_selector 'title', text: full_title('')
    click_link "SENSOR BASE"
    page.should have_selector 'title', text: full_title('')
  end
end
