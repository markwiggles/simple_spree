Deface::Override.new({

                       virtual_path: 'spree/shared/_header',
                       name: 'change_logo',
                       replace: "erb[loud]:contains('logo')",
                       text: "<%= image_tag 'logo.png' %>"
})
