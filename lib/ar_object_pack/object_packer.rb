require 'json'
require 'yaml'

module ArObjectPack
  module ObjectPackager
    # these methods are added directly to the active record base
    # for use like
    #   MyNewClass < ActiveRecord::Base
    #     package field_name, :marshall 
    #   end
    # arguments: meth 
    module ActiveRecordMethods
      def package( meth, pack_type=:marshal )
        raise ArgumentError, "#{meth} is not a database attribute. Perhaps you need to migrate." unless self.columns.collect(&:name).include?( meth.to_s )
        include ArObjectPack::ObjectPackager::InstanceMethods unless self.respond_to?(:do_pack)
        
        pack_type = :marshal unless pack_formats.include?( pack_type )
        self.class_eval %{
          # create new reader 
          def #{meth}
            unpack(self[:#{meth}], '#{pack_type}')
          end
          
          # create new writer
          def #{meth}=(val)
            begin
              self[:#{meth}] = pack(val, '#{pack_type}')
            rescue => e
              raise ArgumentError, "Unable to package this object using #{pack_type}: message - " + e.message
            end    
          end  
        }
      end
      
      private
        def pack_formats
          formats = [:marshal, :json, :yaml, :marshal_64]
          formats | formats.collect(&:to_s)
        end
    end
    
    module InstanceMethods
      private
        def unpack(p_object, pack_type)
          if p_object.class == String
            loaded = do_pack( pack_type ) do |klass, pack_encode|
              # decode if required
              decoded = pack_encode ? Base64.decode64( p_object ) : p_object 
              # use the class to load the data
              decoded = klass.load( decoded )
              return decoded 
            end  
          else
            loaded = p_object
          end    
          loaded
        end
      
        def pack(p_object, pack_type)
          do_pack( pack_type ) do |klass, pack_encode|
            # pack using class
            if klass == JSON
              JSON.dump( p_object)
            end  
            dumped = klass.dump( p_object )
            # encode if necessary
            dumped = Base64.encode64( dumped ) if pack_encode
            return dumped
          end  
        end  
      
        def do_pack( pack_type )
          # determine base pack type and encoding
          pack_type = pack_type.to_s
          pack_encode = false
          if pack_type.include?( "64" )
            pack_encode = true
            pack_type = pack_type[0 .. pack_type.length-4]
          end  
          
          case pack_type
          when "json"
            klass = JSON
          when "yaml"
            klass = YAML
          else
            klass = Marshal
          end  
          
          yield( klass, pack_encode )
        end  
      public  
    end      
  end  
end