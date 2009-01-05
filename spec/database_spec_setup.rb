module DatabaseSpecSetup
  # remove the old database 
  File.delete("object_pack_tester.db")  if File.file?("object_pack_tester.db")

  # send methods to base
  ActiveRecord::Base.send(:extend, ArObjectPack::ObjectPackager::ActiveRecordMethods)

  # establish a connection to the sqlite database
  ActiveRecord::Base.establish_connection(
    :adapter =>   'sqlite3',
    :database =>  'object_pack_tester.db'
  )

  # define a schema
  ActiveRecord::Schema.define do
    # table for testing different packages
    create_table :packages, :force => true do |t|
      t.column :obj,            :text
      t.column :obj_marshal,    :text
      t.column :obj_yaml,       :text
      t.column :obj_json,       :text
      t.column :obj_marshal_64, :text
    end
  
    # table for testing basic database writes and reads to ensure correct setup
    create_table :testings, :force => true do |t|
      t.column :str, :string
    end  
  end

  # Related classes
  class Package < ActiveRecord::Base
    package :obj
    package :obj_marshal,     :marshal
    package :obj_yaml,        :yaml
    package :obj_json,        :json
    package :obj_marshal_64,  :marshal_64
  end  
  
  class Testing < ActiveRecord::Base; end
  
end  