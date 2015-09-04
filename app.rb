require 'active_record'
require 'sqlite3'
require 'uri'
require 'net/http'
require 'json'

ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.column :name, :string
    t.column :username, :string
    t.column :email, :string
    t.column :phone, :string
    t.column :website, :string
  end

  create_table :addresses do |t|
    t.column :user_id, :integer
    t.column :street, :string
    t.column :suite, :string
    t.column :city, :string
    t.column :zipcode, :string
  end

  create_table :geos do |t|
    t.column :address_id, :integer
    t.column :lat, :string
    t.column :lng, :string
  end

  create_table :companies do |t|
    t.column :user_id, :integer
    t.column :name, :string
    t.column :catchPhrase, :string
    t.column :bs, :string
  end
end

class User < ActiveRecord::Base
  has_one :address
  has_one :company
end

class Address < ActiveRecord::Base
  belongs_to :user
  has_one :geo
end

class Geo < ActiveRecord::Base
  belongs_to :address
end

class Company < ActiveRecord::Base
  belongs_to :user
end

# pull down dummy json
uri = URI.parse('http://jsonplaceholder.typicode.com/users')

# 'seed' db
JSON.parse(Net::HTTP.get_response(uri).body).each do |u|
  user = User.create(
    :name     => u['name'],
    :username => u['username'], 
    :email    => u['email'],
    :phone    => u['phone'],
    :website  => u['website']
  ) 

  user.create_company(
    :name         => u['company']['name'],
    :catchPhrase  => u['company']['catchPhrase'],
    :bs           => u['company']['bs']
  )

  address = user.create_address(
    :street   => u['address']['street'],
    :suite    => u['address']['suite'],
    :city     => u['address']['city'],
    :zipcode  => u['address']['zipcode']
  )

  address.create_geo(
    :lat  => u['address']['geo']['lat'],
    :lng  => u['address']['geo']['lng']
  )
end

get '/' do
  # there has got to be a cleaner way to do this, and remove IDs from json
  @users = JSON.parse(User.all.to_json(:include => [:company, :address => {:include => :geo}]))
  haml :index
end
