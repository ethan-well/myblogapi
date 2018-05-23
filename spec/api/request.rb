require 'rails_helper'

describe BlogSite::API do
  it 'articles' do
    get '/api/arts'
    expect(response.body).to eq({ping: 'pong'}.to_json)
  end
end
