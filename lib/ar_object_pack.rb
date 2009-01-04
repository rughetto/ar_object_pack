# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:ar_object_pack] = {}
  
  Merb::BootLoader.before_app_loads do
    # load ObjectPacker into AR Base
    require File.dirname(__FILE__) + '/ar_object_pack/object_packer'
    ActiveRecord::Base.send(:extend, ArObjectPack::ObjectPackager::ActiveRecordMethods)
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
  
  # Merb::Plugins.add_rakefiles "ar_object_pack/merbtasks"
end