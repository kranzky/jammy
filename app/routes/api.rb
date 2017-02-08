get '/api' do
  respond Actions::Games::Search, format: :json
end
