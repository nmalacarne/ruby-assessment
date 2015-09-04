require 'active_record'
require 'sqlite3'

ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

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
