class BlankState
  instance_methods.each { |m| undef_method m unless m =~ /^__|instance_eval|instance_variable_get|instance_variable_set|object_id/ }
end