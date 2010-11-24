class SiteController < ApplicationController
  def index
  end

  def help
  end

  def about
  end

  def search
  end

  def contact
  end

  def test_email
    Emailer.deliver_email_testing "lu.lee05@gmail.com"
    render :text => "go check!"
  end
end
