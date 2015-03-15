require 'rails_helper'

describe UsersController, type: :request do
  describe '#index' do
    it 'renders params' do
      get users_path(q: 'hello')
      expect(response.body).to include('<span>hello</span>')
    end

    it 'renders instance variable' do
      get users_path
      expect(response.body).to include('<p>k0kubun</p>')
    end

    it 'renders rails helper' do
      get users_path
      expect(response.body).to include('<a href="/">root</a>')
    end
  end
end
