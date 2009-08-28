#!/usr/bin/ruby
require  File.dirname(__FILE__) + '/../config/environment'
require 'pp'

Branch.destroy_all
CompanyGroup.destroy_all

Category.all.map { |c|
 if c.children.size>0 
	 Branch.create({:name=>c.name})
  else 
	 CompanyGroup.create({:name=>c.name})
  end
}

Category.all.map { |c|
	if c.parent_id
		parent=Branch.find_by_name(c.parent.name) # || raise "No parent #{c.parent_id}"
		if c.children.size>0
			b=Branch.find_by_name(c.name)
			b.parent_id=parent.id
		else
			g=CompanyGroup.find_by_name(c.name)
			g.branches << parent
		end
	end
}
