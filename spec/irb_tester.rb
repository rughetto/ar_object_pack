#!/usr/bin/env ruby

# This script is modified from one written by Erik Kastner, 
# and a blog describing it's needs and usage can be found at 
# http://metaatem.net/2007/04/20/fun-with-active_record-and-sqlite3
# 
# It can be used for hands on quick and dirty testing to see how the library 
# is working in an established class in IRB. It will open an IRB console with
# the database as specified below, plus the classes defined
# 
# This file must be executable to work: [sudo] chmod 775 irb_tester.rb
# 

require 'rubygems'
require 'active_record'
require 'sqlite3'
require 'irb'
require 'ruby-debug'

File.delete("irb_test.db")  if File.file?("irb_test.db")

require File.dirname(__FILE__) + '/../lib/ar_object_pack/object_packer'
ActiveRecord::Base.send(:extend, ArObjectPack::ObjectPackager::ActiveRecordMethods)

ActiveRecord::Base.establish_connection(
  :adapter =>   'sqlite3',
  :database =>  'irb_test.db'
)

ActiveRecord::Schema.define do
  ActiveRecord::Schema.define do
    create_table :packages, :force => true do |t|
      t.column :obj,            :text
      t.column :obj_marshal,    :text
      t.column :obj_yaml,       :text
      t.column :obj_json,       :text
      t.column :obj_marshal_64, :text
    end
    
    create_table :testings, :force => true do |t|
      t.column :str, :string
    end  
  end
end

class Package < ActiveRecord::Base
  package :obj
  package :obj_marshal,     :marshal
  package :obj_yaml,        :yaml
  package :obj_json,        :json
  package :obj_marshall_64, :marshal_64
end

IRB.start if __FILE__ == $0