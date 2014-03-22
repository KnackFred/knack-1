module ApplicationHelper
  def formatted_price(price, quantity = nil)
    if quantity.nil? || quantity == 1
      "$" + ("%.2f" % price)
    else
     quantity.to_s + " x $" + ("%.2f" % price)
    end
  end
  
  def formatted_date(date)
    Time.parse(date.to_s).strftime("%m/%d/%Y")
  end
  
  def formatted_text(text, length = 50, omission = "...")
    raw truncate(StringHelper.string_to_html(text), :length => length, :omission => omission)
  end

  def formatted_remaining(item, show_one = false)
    if item.Purchased_ID == RegistryItem::AVAILABLE
      if item.Quantity == 1
        if item.contributed > 0 #Show deficient amount
          "$%.2f Remaining" % item.deficient_subtotal.to_f
        elsif show_one
          "1 Requested"
        end
      else
        if item.contributed > 0
          "%.0f of %.0f Available" % [item.deficient_quantity.to_f, item.Quantity]
        else
          "%.0f Requested" % item.Quantity.to_f
        end
      end
    else
      "Purchased"
    end
  end

  def show_flash
    str = ""
    str += "<div class='flash-success'><img class='flash-image' src='/images/apply.png'/><div class='flash-success-text'>#{flash.notice}</div></div>" unless flash.notice.blank?
    str += "<div class='flash-alert'><img class='flash-image' src='/images/error.gif'/><div class='flash-alert-text'>#{flash.alert}</div></div>" unless flash.alert.blank?
    raw str

  end
end
