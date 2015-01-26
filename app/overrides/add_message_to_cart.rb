
Deface::Override.new({
                       virtual_path: 'spree/orders/edit',
                       name: 'add_message_to_cart',
                       insert_after: "[data-hook='outside_cart_form']",
                       text: '<h4 class="text-success text-center"><%= add_message %></h4> '
})