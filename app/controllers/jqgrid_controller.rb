class JqgridController < ApplicationController
  def index
    @ycrole = Ycrole.find 1
  end
end