# helper
require File.dirname(__FILE__) + '/spec_helper'

# gems for testing
require 'rubygems'
require 'active_record'
require 'sqlite3'

# files for testing
require File.dirname(__FILE__) + '/../lib/ar_object_pack/object_packer'

# establish database and test classes
require File.dirname(__FILE__) + "/database_spec_setup"
include DatabaseSpecSetup

describe "ar_object_pack" do
  describe "testing setup: " do
    it "have all the needed gems and files to run" do
      # before block should not throw error and the following should pass!
      true.should == true
    end  
    
    it "should save and retrieve test records normally" do
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
  
  describe 'packaging objects, ' do
    before(:each) do  
      @object = ['1','2','3']
      @instance = Package.new
    end  
    
    it "using the AR package call should not raise errors" do
      lambda {
        instance = Package.new
      }.should_not raise_error
    end  
    
    describe "default pack method" do
      it "should have private methods for pack, unpack and do_pack" do
        @instance.private_methods.should include('pack')
        @instance.private_methods.should include('unpack')
        @instance.private_methods.should include('do_pack')
      end 
    
      it "should pack a field attribute using Marshal if no pack method is defined" do
        Marshal.should_receive(:dump).at_least(:once)
        @instance.obj = @object
      end  
      
      it "should unpack a field attribute using Marshal if no pack method is defined" do
        Marshal.should_receive(:load).at_least(:once)
        @instance.obj = @object
        @instance.obj
      end 
    end

    describe "explicit Marshal packing" do
      it "should pack a field attribute using Marshal when that option is specified" do
        Marshal.should_receive(:dump).at_least(:once)
        @instance.obj_marshal = @object
      end  
      
      it "should unpack a field attribute using Marshal when that option is specified" do
        Marshal.should_receive(:load).at_least(:once)
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
        YAML.should_receive(:dump).at_least(:once)
        @instance.obj_yaml = @object
      end  

      it "should unpack a field attribute using YAML when that option is specified" do
        YAML.should_receive(:load).at_least(:once)
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
        JSON.should_receive(:load).at_least(:once)
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
    
    describe "Encoding with packing" do
      it "should encode a field attribute when that option is specified in the pack_type" do
        Base64.should_receive(:encode64).at_least(:once)
        @instance.obj_marshal_64 = @object
      end  
      
      it "should decode a field attribute when that option is specified in the pack_type" do
        # This seems to be failing even though it is actually working. 
        # The error is bubbling up from the C code. If the should_receive directive is taken out 
        # of the mix no error is raised. So it may be some weirdness with the interaction between
        # Marshal and rpsec ??
        Base64.should_receive("decode64").at_least(:once)
        @instance.obj_marshal_64 = @object
        @instance.obj_marshal_64
      end
  
      it "an object should be the same after packing, saving and unpacking when using encoded data" do
        @instance.obj_marshal_64 = @object
        @instance.save
        @instance.reload
        @instance.obj_marshal_64.should == @object
      end
      
      it "object should not be packed in the same way as unencoded marshal" do
        @instance.obj_marshal_64 = @object
        @instance.obj = @object
        @instance[:obj_marshal_64].should_not == @instance[:obj]
        @instance[:obj_marshal_64].should_not == @object
      end
    end  
    
    describe "an exception should be thrown if" do
      it "packaging method is unable to pack the object" do
        lambda{
          @instance.obj_json = {:something => :else}
        }.should raise_error
      end  
      
      it "package is called on the class for a method name that does not belong to a field attribute" do
        lambda {
          class Package
            package :not_a_field
          end
        }.should raise_error
      end  
    end  
  end  
end