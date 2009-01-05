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

require File.dirname(__FILE__) + "/database_spec_setup"
include DatabaseSpecSetup

IRB.start if __FILE__ == $0