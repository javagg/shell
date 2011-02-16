class SiteController < ApplicationController
  before_filter :require_user, :only => [:download]
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

  def download
  end
  
  def test_email
    Emailer.deliver_email_testing "lu.lee05@gmail.com"
    render :text => "go check!"
  end
end
