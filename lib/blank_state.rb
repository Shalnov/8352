# BlankState object
class BlankState
  # Initializer. Array of arguments allows to keep some methods.
  def self.blank_state(*args)
    methods = "|#{args.join('|')}"
    instance_methods.each { |m| undef_method m unless m =~ /^__|instance_eval|object_id#{methods}/ }
  end
end