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
    module ActsMethods
      def package( meth, pack_type=:marshal )
        include ArObjectPack::ObjectPackager::InstanceMethods
        
        pack_type = :marshal unless pack_formats.include?( pack_type )
        pack_class = 
        
        self.class_eval %{
          # create new readers 
          alias _#{meth} #{meth}
          def #{meth}
            unpack(_#{meth}, #{pack_type})
          end
          
          # create new writers
          alias _#{meth}= #{meth}=
          def #{meth}=(val)
            pack(_#{meth}, #{pack_type})
          end  
        }
      end
      
      private
        def pack_formats
          [:marshal, :json, :yaml, :marshal_64]
        end
    end
    
    module InstanceMethods
      def unpack(meth, pack_type)
        do_pack do |klass, pack_encode|
          # decode if required
          loaded = Base64.decode64( meth ) if pack_encode 
          # use the class to load the data
          loaded = defined?(loaded) ? klass.load( loaded ) : klass( meth )
        end  
        loaded
      end
      
      def pack(meth, pack_type)
        do_pack do |klass, pack_encode|
          # pack using class
          dumped = klass.dump( meth )
          # encode if necessary
          dumped = Base64.encode64( dumped ) if pack_encode
        end  
        dumped
      end  
      
      private
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
            klass = YAMl
          else
            klass = Marshal
          end  

          yield( klass, pack_encode )
        end  
    end      
  end  
end