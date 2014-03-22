class ContributeObserver < ActiveRecord::Observer
  def after_create(cont)
    cont.registry_item.update_for_added_contribution(cont)
    cont.registry_item.save
  end

  def after_update(cont)
    if cont.Contribute_changed?
      cont.registry_item.update_for_changed_contribution(cont)
      cont.registry_item.save
    end
  end

  def after_destroy(cont)
    cont.registry_item.update_for_deleted_contribution(cont)
    cont.registry_item.save
  end
end
