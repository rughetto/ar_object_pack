if defined?(Merb::Plugins)
  Merb::Plugins.config[:ar_object_pack] = {} # nothing yet needed
  
  Merb::BootLoader.before_app_loads do
    # load ObjectPacker into AR Base
    require File.dirname(__FILE__) + '/ar_object_pack/object_packer'
    ActiveRecord::Base.send(:extend, ArObjectPack::ObjectPackager::ActiveRecordMethods)
    
    # load ObjectPacker into AR Base
    # require File.dirname(__FILE__) + '/ar_object_pack/set_typer'
    # ActiveRecord::Base.send(:extend, ArObjectPack::SetTyper::ActiveRecordMethods)
  end
  
  Merb::BootLoader.after_app_loads do
    # nothing yet needed 
  end
end