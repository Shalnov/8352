class Branch < ActiveRecord::Base
  acts_as_nested_set

  has_many :branch_company_groups, :order => "position ASC"  
  has_many :groups, :through => :branch_company_groups, :source => :company_group

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
  def self.tree(objects)
    by_id = Hash[*(objects.map { |o| [o.id, o] }.flatten)]
  
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
    
    flat_tree = {}
    by_path.sort { |a, b| a[0].length <=> b[0].length }.each do |value|
      path, branch = value
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
         
    proxy_index = {}
    flat_tree.each do |id, item|
      proxy_item = TreeProxy.new(item[:object], proxy_index, item.except(:object))
      proxy_index[id] = proxy_item
    end    

    # Returns proxies of a roots.
    proxy_index.values.find_all { |item| item.root.nil? }.sort do |a, b| 
      a[left_column_name] <=> b[left_column_name]          
    end
  end
end
