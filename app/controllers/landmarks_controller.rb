class LandmarksController < ApplicationController
  
  get '/landmarks/new' do 
    erb :"landmarks/new"
  end
  
  post '/landmarks' do 
    @landmark = Landmark.find_or_create_by(name: params["landmark"]["name"])
    if params["title"]["name"] != ""
      @title = Title.find_or_create_by(name: params["title"]["name"])
      @landmark.title = @title 
      @title.landmarks << @landmark 
      @landmark.save 
    end
    
    if params["landmark"]["year_completed"] != ""
      @landmark.year_completed = params["landmark"]["year_completed"]
      @landmark.save 
    end
    erb :"landmarks/show"
  end
  
  get '/landmarks' do 
    @landmarks = Landmark.all 
    erb :"landmarks/index"
  end
  
  get '/landmarks/:id' do 
    @landmark = Landmark.find(params[:id])
    erb :"landmarks/show"
  end
  
  get '/landmarks/:id/edit' do 
    @landmark = Landmark.find(params[:id])
    erb :"landmarks/edit"
  end
  
  patch '/landmarks/:id' do 
    @landmark = Landmark.find(params[:id])
    
    if params["landmark"]["name"] != ""
      @landmark.name = params["landmark"]["name"]
      @landmark.save 
    end
    
    if params["landmark"]["year_completed"] != ""
      @landmark.year_completed = params["landmark"]["year_completed"]
      @landmark.save 
    end
    
    redirect "/landmarks/#{@landmark.id}"
  end
end
