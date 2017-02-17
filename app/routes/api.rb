get '/api/games' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  respond Actions::Games::Search, format: :json
  # respond games: "search", format: :json
end
