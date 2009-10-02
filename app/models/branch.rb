class Branch < ActiveRecord::Base
  acts_as_nested_set

  has_and_belongs_to_many :groups, :class_name => "CompanyGroup", :order => "name ASC"

  named_scope :with_groups, { :include => :groups }
  default_scope :order => "lft"
    
  def move_to_left_or_right(target)
    target = target.is_a?(Fixnum) ? self.class.find(target) : target
    if left > target.right
      move_to_left_of(target)
    else
      move_to_right_of(target)
    end
  end    

  # TODO: А тут бы я сделал так: сначала выбрал бы все ID, а потом уже все объекты.
  # Т.е. descendants -> массив ID, Group.find_by_branch_id(массив ID).collect id, Company.find_by_group_id.
  # Получится три запроса вместо N.
  # Всё-таки, парное программирование и ревизионирование рулит.
  # Виктор.
  def companies
    c=[]
    gs=groups
    descendants.map { |d| 
      gs=gs+d.groups
    }
    gs.map { |g| 
      c=c+g.companies
    }
    c
  end

  def breadcrumb
    self.root? ? [self] : self.parent.breadcrumb + [self]
  end

  # Очень длинная функция для рекурсивного обхода плоского дерева.
  # По-моему, можно её значительно упростить, но я не знаю как.
  # Вернее, второй способ потребует многократного обхода плоского массива для поиска, например, 
  # следующего парента (конец саблингов), и парентов до рута. Может, более простой код лучше?
  # Требования: входной массив должен быть отсортирован по lft.
  def self.tree(objects, &block)
    # Справочный массив для дальнейших калькуляций
    by_id = Hash[*(objects.map { |o| [o.id, o] }.flatten)]
  
    # Калькулейт материализед патчс!
    # По факту, этот кусок разбивает дерево на хэш веток, где ключом является путь к ветке,
    # а значением - массив объектов.
    by_path = {}    
    path = [nil]    
    objects.each do |o|
      if o.parent_id != path.last
        if path.include?(o.parent_id)
          path.pop while path.last != o.parent_id
        else
          path << o.parent_id
        end
      end
      (by_path[path.slice(1..-1)] ||= []) << o
    end    
    
    # Проводим вычисления для всех веток дерева. Пока во все места записываем ID
    flat_tree = {}
    by_path.each do |path, branch|
      branch.each do |o|
        branch_index = branch.index(o)
        tree_item = {
          :object => o,
          :root => path.first,
          :parent => o.id,
          :ancestors => path,
          :children => [],
          :descendants => branch.slice(branch_index..-1).map { |b| b.id },
          :siblings => [],
          :level => path.length
        }
        tree_item[:siblings] = branch.slice(0..branch_index-1).map { |b| b.id } if branch_index > 0        
        flat_tree[o.id] = tree_item
        
        if flat_tree.key?(o.parent_id)
          flat_tree[o.parent_id][:children] << o.id
        end
      end
    end
         
    # Создаём прокси-объекты.
    proxy_index = {}
    flat_tree.each do |id, item|
      proxy_item = TreeProxy.new(item[:object], proxy_index, item.except(:object))
      proxy_index[id] = proxy_item
    end    
      
    # Возвращаем корни
    proxy_index.values.find_all { |item| item.root.nil? }.sort { |a, b| a.lft <=> b.lft }
  end
end
