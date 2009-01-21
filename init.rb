require 'lib/ar_object_pack/object_packer'
ActiveRecord::Base.send(:extend, ArObjectPack::ObjectPackager::ActiveRecordMethods)

require 'lib/ar_object_pack/set_typing'
ActiveRecord::Base.send(:extend, ArObjectPack::SetTyping::ActiveRecordMethods)