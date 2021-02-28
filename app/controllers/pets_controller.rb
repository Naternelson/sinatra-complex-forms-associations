class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index' 
  end

  get '/pets/new' do
    @owners = Owner.all 
    erb :'/pets/new'
  end

  post '/pets' do 
    @pet = Pet.create(name: params[:pet_name])
    if !params[:owner_name].empty?
      owner = Owner.create(name: params[:owner_name])
      owner.pets << @pet
    else
      owner = Owner.find_by(id: params[:owner])
      owner.pets << @pet
    end
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id/edit' do
    @owners = Owner.all
    @pet = Pet.find_by(id: params[:id])
    if !@pet
      redirect to '/pets'
    end
    erb :'/pets/edit'
  end

  get '/pets/:id' do 
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  patch '/pets/:id' do 
     ####### bug fix
    if !params[:pet].keys.include?("owner_id")
      params[:pet]["owner_id"] = []
    end
      #######

    @pet = Pet.find(params[:id])
    @pet.name = params["pet_name"]
    if !params["owner"]["name"].empty?
      @pet.owner = Owner.create(name: params["owner"]["name"])
      @pet.save
    else
      @pet.owner = Owner.find(params[:pet][:owner_id])
      @pet.save
    end
    redirect to "pets/#{@pet.id}"
  end
end