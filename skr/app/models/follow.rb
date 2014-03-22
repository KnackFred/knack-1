class Follow < ActiveRecord::Base

  belongs_to :registrant  # The source
  belongs_to :followed, :class_name => "Registrant" # The Destination

  validates :registrant_id,
            :presence => true,
            :numericality  => {:greater_than_or_equal_to => 0,
                               :only_integer => true}

  validates :followed_id,
            :presence => true,
            :numericality  => {:greater_than_or_equal_to => 0,
                               :only_integer => true}

  validates_uniqueness_of :registrant_id, :scope => :followed_id

  validate :no_self_reference

  def no_self_reference
    errors.add(:followed_id, "can't follow yourself") if registrant_id == followed_id
  end

end