require 'pry'
class FiguresController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  register Sinatra::Twitter::Bootstrap::Assets
  
  get "/figures/new" do 
    @titles = Title.all 
    @landmarks = Landmark.all 
    erb :"figures/new"
  end
  
  post "/figures" do
    @figure = Figure.find_or_create_by(name: params["figure"]["name"])
  
    if !params["figure"]["landmark_ids"].nil?
      params["figure"]["landmark_ids"].each do |landmark_id|
        found_landmark = Landmark.find(landmark_id)
        @figure.landmarks << found_landmark
      end
    end

    if !params["figure"]["title_ids"].nil?
      params["figure"]["title_ids"].each do |title_id|
        found_title = Title.find(title_id)
        @figure.titles << found_title
      end
    end

    if params["landmark"]["name"] != ""
      @landmark = Landmark.find_or_create_by(name: params["landmark"]["name"])
      @figure.landmarks << @landmark
    end

    if params["title"]["name"] != ""
      @title = Title.find_or_create_by(name: params["title"]["name"])
      @figure.titles << @title
    end
  
    erb "figures/show"
  end
  
  get '/figures' do 
    @figures = Figure.all 
  
    erb :"figures/index"
  end

  get '/figures/:id' do 
    @figure = Figure.find(params[:id])
    erb :"figures/show"
  end
  
  get '/figures/:id/edit' do 
    @figure = Figure.find(params[:id])
    @landmarks = Landmark.all 
    @titles = Title.all 
    
    erb :"/figures/edit"
  end
  
  patch '/figures/:id' do 
    @figure = Figure.find(params[:id])
    
    if !params["figure"]["landmark_ids"].nil?
      params["figure"]["landmark_ids"].each do |landmark_id|
        found_landmark = Landmark.find(landmark_id)
        @figure.landmarks << found_landmark
      end
    end

    if !params["figure"]["title_ids"].nil?
      params["figure"]["title_ids"].each do |title_id|
        found_title = Title.find(title_id)
        @figure.titles << found_title
      end
    end

    if params["figure"]["name"] != ""
      @figure.name = params["figure"]["name"]
      @figure.save
    end
    
    if params["landmark"]["name"] != ""
      @landmark = Landmark.find_or_create_by(name: params["landmark"]["name"])
      @figure.landmarks << @landmark
    end

    if params["title"]["name"] != ""
      @title = Title.find_or_create_by(name: params["title"]["name"])
      @figure.titles << @title
    end
    redirect "/figures/#{@figure.id}"
  end
end