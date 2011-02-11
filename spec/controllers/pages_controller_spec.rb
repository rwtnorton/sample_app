require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = 'Ruby on Rails Tutorial Sample App'
  end

  describe "GET 'home'" do
    before(:each) do
      get 'home'
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector('title',
                                    :content => @base_title + ' | Home')
    end
  end

  describe "GET 'contact'" do
    before(:each) do
      get 'contact'
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector('title',
                                    :content => @base_title + ' | Contact')
    end
  end

  describe "GET 'about'" do
    before(:each) do
      get 'about'
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector('title',
                                    :content => @base_title + ' | About')
    end
  end

  describe "GET 'help'" do
    before(:each) do
      get 'help'
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector('title',
                                    :content => @base_title + ' | Help')
    end
  end

end
