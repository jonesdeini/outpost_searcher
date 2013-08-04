require "sinatra"

get "/" do
  # steam_id = params[:steam_id]
  steam_id = "76561198015466913"

  if steam_id
    Main.go!(steam_id)
  end
end
