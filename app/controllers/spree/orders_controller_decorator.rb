Spree::OrdersController.class_eval do

	include Spree::Core::ControllerHelpers
 
  def add_message

   current_order.item_count < 2 ? "10% discount for orders of 2 or more" : "Checkout now for fast delivery"
  
  end

  helper_method :add_message
end