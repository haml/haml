class UsersController < ApplicationController
  def index
    @user = { id: 1, name: 'k0kubun' }
  end
end
