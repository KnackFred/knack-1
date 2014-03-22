module BrowseHelper

  # Set current category id to -1 and what's hot will be selected.
  def category_tree(category, current_category, expanded_categories, depth = 0)
    tag = "<div style='margin-left:#{(10 * depth).to_s}px'>"
    # Add a link to the hot path
    if depth == 0
      tag += "<a href='/hot' class='top-category #{current_category == Category.hot ? "top-category-on" : "top-category-off"}'> What's Hot <img src='/images/general/hot-16.png' alt='flame'/></a>"
    end
    category.children.visible.each do |child|
      class_str = (child == current_category ? "category-link current-link" : "category-link")
      if category.is_root?
        class_str << " top-category"
        if expanded_categories.include?(child.id)
          class_str << " top-category-on"
        else
          class_str << " top-category-off"
        end
      end

      tag += "<a class='"+ class_str +"' href='/catalog/#{child.id}'>#{child.name}</a>"
      tag += "<br/>" unless category.is_root?

      if expanded_categories.include?(child.id)
        tag += category_tree(child, current_category, expanded_categories, depth + 1)
      end
    end
    tag += "</div>"
    raw tag
  end

  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end

  def social_picture(registrant)
    if registrant.fbuid
      image_tag "https://graph.facebook.com/#{registrant.fbuid}/picture"
    else
      image_tag registrant.profile_image.url(:small)
    end
  end
end
