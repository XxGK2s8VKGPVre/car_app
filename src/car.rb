require 'mongo'
require 'mongoid'

class Car
  include Mongoid::Document
  
  field :name, type: String
  field :departure_time, type: String
  field :humans, type: Array
    
  def set_departure_time(time)
    self.departure_time = time
    self.save
  end
  
  def add_human(name, keys = false)
    self.humans.each { |human| human["keys"] = false} unless self.humans.empty?
    self.humans << { "name" => name, "keys" => keys }
    self.save
  end
  
  def eliminate_human(name)
    self.humans.delete_if { |human| human["name"] == name }
    self.save
  end
end

def create_new_car(name, humans = [], departure_time = "No Time Yet")
  Car.create(
  name: name,
  departure_time: departure_time,
  humans: humans
  )
end

def delete_car(id)
  Car.find(id).delete
end

def find_car(id)
  Car.find(id)
end


def get_cars
  list_of_cars = []
  Car.each { |car| list_of_cars << car }
  list_of_cars
end