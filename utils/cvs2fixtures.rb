#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment.rb'
require File.dirname(__FILE__) + '/../lib/acts_as_taggable.rb'
#require 'active_support'
#require 'action_controller'

#require 'fileutils'
#require 'optparse'
require 'csv'
#ENV['RAILS_ENV']='development'
$KCODE = 'u'

old_cat=nil
category=nil
  # раздел, наименование, адрес, телефоны, веб-сайт, email, Время работы
CSV::Reader.parse(File.open(ARGV[0], 'rb')) do |row|
  (cat,name,address,tels,site,email,work_time,comment)=row
  next if cat=='Раздел'
  unless cat.nil?
#    category.save unless old_cat.nil?
    old_cat=cat
    category=Category.create(:name=>cat)
 #   p category
  end
  company=Company.create(:name=>name,:full_name=>name,
                      :address=>address,:site=>site,
                      :description=>comment,
                                    :category_id=>category.id)
  
  if tels!=nil
    p=/(\d+)\s*(\((.+)\))?/
    filials = tels.split(",")
#    print tels
    filials.each do |f|
      f=f.sub(/^\s+/,'')
      refs=p.match(f).to_a
      number=refs[1]
      dep=refs[3]
      number=f.sub(/\s+$/,'')
#      p refs
      phone=Phone.create(:number=>number,:department=>dep,
                         :company_id=>company.id)
      p phone
#      phone.save
    end
  end
  if email!=nil
    e=Email.create(:email=>email,
                    :company_id=>company.id)
  end
#  company
#  company.save

#  p category
  
#  break if !row[0].is_null && row[0].data == 'stop'
end
