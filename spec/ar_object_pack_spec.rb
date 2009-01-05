# helper
require File.dirname(__FILE__) + '/spec_helper'

# gems for testing
require 'rubygems'
require 'active_record'
require 'sqlite3'

# files for testing
require File.dirname(__FILE__) + '/../lib/ar_object_pack/object_packer'

describe "ar_object_pack" do
  # build the database and send library to AR base
  before(:all) do
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
  
  after(:all) do
    # cleanup!
    File.delete("object_pack_tester.db")  if File.file?("object_pack_tester.db")
    File.delete("irb_test.db") if File.file?("irb_test.db")
  end  
  
  describe "testing setup: " do
    it "have all the needed gems and files to run" do
      # before block should not throw error and the following should pass!
      true.should == true
    end  
    
    it "should save and retrieve test records" do
      class Testing < ActiveRecord::Base; end
      testing = Testing.new(:str => "my new string")
      testing.should be_new_record
      testing.save
      testing.should_not be_new_record
      testing.str.should == "my new string"
    end  
  end  
  
  describe "Methods are added to ActiveRecord::Base, " do
    it '#package is a method available in ActiveRecord::Base' do
      ActiveRecord::Base.methods.include?( "package" ).should == true
    end  
  end  
  
  describe 'packaging objects' do
    before(:all) do
      class Package < ActiveRecord::Base
        package :obj
        package :obj_marshal,     :marshal
        package :obj_yaml,        :yaml
        package :obj_json,        :json
        package :obj_marshall_64, :marshal_64
      end  
      @class = Package
    end
    
    before(:each) do  
      @object = ['1','2','3']
      @instance = @class.new
    end  
    
    it "using the AR package call should not raise errors" do
      lambda {
        instance = @class.new
      }.should_not raise_error
    end  
    
    describe "default pack method" do
      it "should have private methods for pack, unpack and do_pack" do
        @instance.private_methods.should include('pack')
        @instance.private_methods.should include('unpack')
        @instance.private_methods.should include('do_pack')
      end 
    
      it "should pack a field attribute using Marshal if no pack method is defined" do
        Marshal.should_receive(:dump)
        @instance.obj = @object
      end  
      
      it "should unpack a field attribute using Marshal if no pack method is defined" do
        Marshal.should_receive(:load)
        @instance.obj = @object
        @instance.obj
      end 
    end

    describe "explicit Marshal packing" do
      it "should pack a field attribute using Marshal when that option is specified" do
        Marshal.should_receive(:dump)
        @instance.obj_marshal = @object
      end  
      
      it "should unpack a field attribute using Marshal when that option is specified" do
        Marshal.should_receive(:load)
        @instance.obj_marshal = @object
        @instance.obj_marshal
      end
  
      it "an object should be the same after packing, saving and unpacking with Marshal method" do
        @instance.obj_marshal = @object
        @instance.save
        @instance.reload
        @instance.obj_marshal.should == @object
      end
    end
        
    describe "YAML packing" do
      it "should pack a field attribute using YAML when that option is specified" do
        YAML.should_receive(:dump)
        @instance.obj_yaml = @object
      end  

      it "should unpack a field attribute using YAML when that option is specified" do
        YAML.should_receive(:load)
        @instance.obj_yaml = @object
        @instance.obj_yaml
      end
  
      it "an object should be the same after packing and unpacking with YAML method" do
        @instance.obj_yaml = @object
        @instance.save
        @instance.reload
        @instance.obj_yaml.should == @object
      end
      
      it "object should not be packed in the same way as marshal" do
        @instance.obj_yaml = @object
        @instance.obj = @object
        @instance[:obj_yaml].should_not == @instance[:obj]
      end  
    end  
    
    describe "JSON packing" do
      it "should pack a field attribute using JSON when that option is specified" do
        JSON.should_receive(:dump).at_least(:once)
        @instance.obj_json = @object
      end  

      it "should unpack a field attribute using JSON when that option is specified" do
        JSON.should_receive(:load)
        @instance.obj_json = @object
        @instance.obj_json
      end
  
      it "an object should be the same after packing and unpacking with JSON method" do
        @instance.obj_json = @object
        @instance.save
        @instance.reload
        @instance.obj_json == @object
      end
      
      it "object should not be packed in the same way as marshal" do
        @instance.obj_json = @object
        @instance.obj = @object
        @instance[:obj_json].should_not == @instance[:obj]
      end  
    end
    
  end  
  

end