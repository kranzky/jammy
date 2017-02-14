get '/api/games' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  params[:page] = params[:page].to_i if params[:page].present?
  respond Actions::Games::Search, format: :json
end
