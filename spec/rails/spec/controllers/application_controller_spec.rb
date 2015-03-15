require 'rails_helper'

describe ApplicationController, type: :request do
  describe '#index' do
    it 'renders views' do
      get root_path
      expect(response).to be_ok
      expect(response).to render_template('application/index')
      expect(response).to render_template('layouts/application')
      expect(response.body).to include('<span>Hamlit</span>')
    end
  end
end
