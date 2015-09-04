require 'active_record'
require 'sqlite3'

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
    t.column :address_it, :integer
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
