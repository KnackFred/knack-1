module RegistrantHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
  end

  def skim_link(url, registrant_id = 0)
    url = url.strip()
    url = "http://" + url[8...url.length-8] if url.starts_with?("https://")
    url = "http://" + url unless url.start_with?("http://")

    begin
      host = URI.parse(url).host

      if host[/target.com\Z/]
        "http://gan.doubleclick.net/gan_click?lid=41000000000553798&pubid=21000000000564404&adurl=#{u(url)}"
      else
        "http://go.knackregistry.com/?id=29424X871720&xs=1&url=#{u(url)}&xcust=#{registrant_id}"
      end
    rescue
      url
    end
  end

  def contributor_names(item)
    if item.order_line_items.empty?
      ""
    elsif item.order_line_items.size == 1
      item.order_line_items.first.from
    else
      commaed_list = item.order_line_items - [item.order_line_items.last]
      "#{commaed_list.map(&:from).join(', ')} and #{item.contributes.last.From}"
    end
  end
end
