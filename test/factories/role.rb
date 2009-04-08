Factory.define :admin_role, :class => :role do |r|
  r.name 'admin'
end

Factory.define :editor_role, :class => :role do |r|
  r.name 'editor'
end