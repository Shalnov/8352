class Tagging < ActiveRecord::Base
  belongs_to :tag, :counter_cache => true

  belongs_to :taggable, :polymorphic => true

  validates_presence_of :email
end
