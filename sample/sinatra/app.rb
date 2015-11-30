require 'sinatra'
require 'hamlit'

User = Struct.new(:id, :name)

set :haml, format: :html5

get '/' do
  @notice = 'hello'
  @users = [
    User.new(1, 'k0kubun'),
    User.new(2, 'hello'),
  ]
  haml :index
end

get '/center' do
  @notice = 'centering'
  @users = [User.new(3, 'neko')]
  haml :index, layout: :center
end
