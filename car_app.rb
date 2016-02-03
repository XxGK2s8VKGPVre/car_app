require 'sinatra/base'
require 'sinatra/assetpack'

#Require local sources
require './src/car'

class CarApp < Sinatra::Base
  Mongoid.load!("./config/mongoid.yml", :test)

  set :root, File.dirname(__FILE__)
  register Sinatra::AssetPack

  assets {
    serve '/css',    from: 'app/css'
    serve '/js',    from: 'app/js'
    serve '/img',    from: 'app/img'
    
    js :app, [
      '/js/*.js'
    ]
        
    css :application, [
      '/css/main.css', '/css/flat-ui.css'
    ]
    css_compression :less
    prebuild true
  }

  get '/' do
    @cars = get_cars
    erb :cars  
  end
  
  get '/modify_cars' do
    @cars = get_cars
    erb :modify_cars
  end

  post '/new_car' do
    name = params[:name]
    create_new_car(name)
    redirect '/modify_cars'
  end

  get '/set_departure_time/:car_id' do
    @car_id = params[:car_id]
    erb :set_departure_time
  end

  post '/set_departure_time' do
    departure_time = params[:departure_time]
    car = find_car(params[:car_id])
    car.set_departure_time(departure_time)
    redirect '/'
  end

  get '/modify_humans/:car_id' do
    @car = find_car(params[:car_id])
    erb :modify_humans
  end

  post '/add_human' do
    car_id = params[:car_id]    
    find_car(car_id).add_human(params[:human_name], params[:keys] == "true" ? true : false)
    redirect "/modify_humans/#{car_id}"
  end
  
  post '/eliminate_human' do
    car_id = params[:car_id]
    find_car(car_id).eliminate_human(params[:human_to_eliminate])
    redirect "/modify_humans/#{car_id}"
  end
  
  get '/remove_car/:car_id' do
    car_id = params[:car_id]
    delete_car(car_id)
    redirect '/'
  end
end