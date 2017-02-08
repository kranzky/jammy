get '/api/games' do
  respond Actions::Games::Search, format: :json
end
