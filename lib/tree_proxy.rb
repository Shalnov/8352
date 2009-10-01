# Прокси-класс для элемента дерева, которое перевели в форму дерева из плоской.
class TreeProxy < BlankState
  # Этот метод возвращает прокси-объект или массив прокси из индекса.
  %w{root parent ancestors children descendants siblings level}.each do |attr|
    define_method attr.to_sym do
      value = instance_variable_get("@#{attr}")
      if value.is_a?(Array)
        value.map { |id| @proxy_index[id] } || []
      else
        @proxy_index[value]
      end
    end
  end  
  
  attr_reader :level

  # На вход принимается объект, индекс всех прокси.
  def initialize(subject, proxy_index, *args)
    @subject = subject
    @proxy_index = proxy_index
    options = args.extract_options!
    options.each { |key, value| instance_variable_set("@#{key}", value) }
  end

private
  def method_missing(method, *args, &block)
    raise NotImplementedError, "This method: #{method} is not implemented on #{@subject.class_name}" unless @subject.respond_to?(method)
    @subject.send(method, *args, &block)
  end
end