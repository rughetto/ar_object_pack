require 'ar_object_pack/object_packer'
ActiveRecord::Base.send(:extend, ArObjectPack::ObjectPackager::ActiveRecordMethods)