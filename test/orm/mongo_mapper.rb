MongoMapper.database = "devise-test-suite"
MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)

require File.expand_path('../../rails_app/config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  setup do
    User.delete_all
    Admin.delete_all
  end
end