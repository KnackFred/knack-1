class ErrorMessages
  DIFFERENT = 0
  IMAGE_FORMAT = 1
  MIXED_CART = 2
  IMAGE_PDF_FORMAT = 3
  NOT_FOUND = 4
  ALREADY_IN_CART = 5
  CUSTOM = 6
  VALIDATION = 7

  def self.get_text_error(id, message = '')
    case id.to_i
      # Error image file size
      when IMAGE_FORMAT
        message = "You can upload JPG, JPEG, GIF or PNG files under 3 MB."
      when MIXED_CART
        message = '<b>"Place Order and Ship It"</b> requests and <b>"Cash Value"</b>
        requests unfortunately cannot be handled simultaneously. Please remove some
        requests in your cart so that we can process your order.'
      when IMAGE_PDF_FORMAT
        message = "You can upload JPG, JPEG, GIF, PNG or PDF files under 3 MB."
      when NOT_FOUND
        message = "Not found."
      when ALREADY_IN_CART
        message = "This item is already placed in the cart."
      when CUSTOM
        message
      when VALIDATION
        message = 'Validation Error.  Please check your values and try again.'
      else
        message = "We apologize for the error.  Something went wrong and we'd appreciate if you wrote the Knack helpdesk (<a href= 'mailto:support@knackregistry.com' >support@knackregistry.com</a>) with information about the sequence of events that led to this error."
    end
    
    message.html_safe
  end
end