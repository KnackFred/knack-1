class Section < ActiveRecord::Base

  belongs_to :registrant

  has_many :registry_items,
           :order => 'registry_items.order, registry_items.created_at DESC',
           :conditions => "registry_items.isDeleted = false"
  accepts_nested_attributes_for :registry_items

  validates :title,
                        :length => {:minimum => 0, :maximum => 50}

  validates :description,
                        :length => {:minimum => 0, :maximum => 300}

  validates :order,
                        :numericality => {:only_integer => true, :less_then => 10}

end
