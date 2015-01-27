# Simple Spree Store
<h2>Example of adding Spree to an existing Rails app</h2>

<i>Note: if you wish to clone this project, it will ask you to run rake to create the db, which give you a working Spree site with no products. If you want the sample data, then re-install Spree. The routing to the product page won't work until there is a product with id: 17, so you may need to update this.  The files in the overrides directory will also be commented out, so you can play with them to get an idea of how the code affects the view/s.</i>


<h4>Contents</h4>

[Required Gems](#required-gems)

[Install Spree](#install-spree)

[Install Bootstrap](#install-bootstrap-frontend)

[Create New Product](#create-new-product)

[Adding Routes](#adding-routes)

<hr>

[Customising Views](#customising-views)
*  [Virtual Path](#virtual-path)
*  [Deface Overrides](#deface-overrides)
*  [DSL Method](#dsl-method)

<hr>

[Customising Logic](#customising-logic)
*  [Controller Helpers](#controller-helpers)
*  [Decorators](#decorators)

<hr>

[More.....](#more)
* [Spree API](#spree-api)
* [Spree with Ember](spree-with-ember)

----

<h3>Required Gems</h3>

Add the Spree stable build, the <i>bootstrap</i> gem for the frontend, as well as the Devise authentication gem.

```ruby
gem 'spree', github: 'spree/spree', branch: '2-4-stable'
gem 'spree_bootstrap_frontend', github: '200Creative/spree_bootstrap_frontend'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-4-stable'
```
If you are adding Spree, where you already use Devise, then leave out the <i>spree_auth_devise</i> gem, and follow the [Spree Custom Authentication Developer Guide](https://guides.spreecommerce.com/developer/authentication.html) to continue with your pre-existing user model. 

Optionally, if you need volume pricing breaks, add the following gem.
```ruby
gem 'spree_volume_pricing', github: 'spree-contrib/spree_volume_pricing'
```
At this point, check your version of rails, otherwise there may be conflicts.

```ruby
gem 'rails', '4.1.8'
```
Then run bundle install.

<h3>Install Spree</h3>

Unless you have used Spree before, it is a good idea to load your first project with the sample data as it will give you the opportunity to explore the setup including configuration, taxons, freight etc. If you don't want the sample data,  pass the additional arguments  <i> --sample --seed </i>.  See the Spree Github for more info.

```
rails g spree:install
```
<h5>Problems Installing</h5>
If you get a message re the installation of <i>Nokogiri</i> (HTML parser) gem, then it may be as simple as updating your Xcode tools, installing the Nokogiri gem first, or else this link may help - [Installing Nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html).

Reload your webpage and you should now see the Spree frontend site with products. We will fix the routing later, to get your original page back. The Spree page will be a bit ugly, but nothing some <i>bootstrap</i> css can't fix!


<h3>Install Bootstrap Frontend</h3>
```
rails g spree_bootstrap_frontend:install
```

Spree also uses the <i>font-awesome</i> gem which can be helpful in your markup. To use this, you will need to change the `application.css` to file to `application.scss` and add the following. 

```ruby
@import "font-awesome";

```

<h3>Create New Product</h3>
Navigate to the backend using <i>/admin</i> and you be asked to login (use the email you specified in the install eg. spree@example.com, and password).  You will see the admin area where you can navigate to Products -> +New Product, where you can add a product name, price, image etc.
![alt text](https://github.com/markwiggles/simple_spree/raw/master/app/assets/images/taxons.png "taxons")



<h3>Adding Routes</h3>
In `routes.rb`
* mount Spree at `/shop` (or whatever)
* Add a route which will navigate direct to the product that you want to sell. For this you will need to get the integer id for newly created product (here it is 17), from your database products table.  You can either specify this as the root, or create a path using the id, perhaps adding more paths later for new products.

```ruby
# We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
mount Spree::Core::Engine, :at => '/shop'

Spree::Core::Engine.routes.draw do
  get :obama, to: 'products#show', as: :buy_obama, :id => 17
  root to: 'products#show', as: 'buy_product', :id => 17
end
```
You may like to run `rake:routes` to check that your routes are there.

The original webpage will now return as the root page, and you will be able to navigate to the Spree site using  `/shop` or in your code as `spree.buy_obama_path` (note the namespace call), or `spree_path` for the the root path.



<h3>Customising Views</h3>

<h4>Spree Deface Library</h4>

<blockquote>"Deface is a standalone Rails library that enables you to customize Erb templates without needing to directly edit the underlying view file. Deface allows you to use standard CSS3 style selectors to target any element (including Ruby blocks), and perform an action against all the matching elements"  <i>...Spree docs</i> </blockquote> 

See the full documentation in the [Spree Deface Github](https://github.com/spree/deface), and the [Spree Developer Guide](https://guides.spreecommerce.com/developer/view.html).



<h5>Deface Overrides</h5>

Using Deface, we will change parts of the view, namely:

1. Remove Search Bar
2. Change Logo
3. Add Links
4. Add Credit Card Icons
5. Change Favicon


Spree will first look in the <i>app/overrides</i> folder, so create ruby files for each of the operations, (convention is to have one file for each action, unless the tasks are closely related).<br>
Replacements/Insertions can accept: text; partial (relative path); template (relative path).


<blockquote>
"We will endeavour to ensure that data-hook / id combination will remain consistent within any single view file (where possible), thus making your overrides more robust and upgrade proof."  <i>...Spree docs</i> </blockquote>



<h5>Virtual Path</h5>

You need to ensure that you target the correct file to get the <i>virtual path</i>, and this can be done by either:
* Searching the Spree Github (under the correct version)
* Run `bundler show spree` and use this in text editor files search (eg Sublime)
* Rubymine - find in path -> custom -> projects and libraries

<br>


<h5>1. Remove Search Bar</h5>

```ruby
Deface::Override.new({
                       virtual_path: 'spree/shared/_nav_bar',
                       name: 'remove_search',
                       remove: '#search-bar'
})
```
<br>


<h5>2. Change Logo</h5>

```ruby
Deface::Override.new({
                       virtual_path: 'spree/shared/_header',
                       name: 'change_logo',
                       replace: "erb[loud]:contains('logo')",
                       text: "<%= image_tag 'logo.png' %>"
})
```
<br>


<h5>3. Add Links</h5>

```ruby
website_link = "<li id='home-website-link' data-hook><%= link_to 'Website', main_app.root_path %></li>"
admin_link = "
<% if is_admin? %>
<li id='admin-link' data-hook><%= link_to 'Spree Admin', spree.admin_login_path %></li>
<% end %>"

Deface::Override.new({
                       virtual_path: 'spree/shared/_main_nav_bar',
                       name: 'add_links',
                       insert_before: '#home-link',
                       text: "#{website_link} #{admin_link}"
})
```
<br>


<h5>4. Add Credit Card Icons</h5> 
![alt text](https://github.com/markwiggles/simple_spree/raw/master/app/assets/images/amex.png "amex")

```ruby
Deface::Override.new({
                       virtual_path: 'spree/products/show',
                       name: 'add_credit_cards',
                       insert_after: '#cart-form',
                       partial: 'partials/credit_cards'
})
```

<h5>5. Change Favicon</h5>

```ruby
Deface::Override.new({

  virtual_path: 'spree/shared/_head',
    name: 'change_favicon',
    replace: "erb[loud]:contains('favicon')",
    text: "<%= favicon_link_tag 'obama_favicon.ico' %>"
})
```


<h3>DSL Method</h3>

As an alternative to separate override files, create a directory structure matching the path of the view template, with the last directory as the filename, with the override file.

![alt text](https://github.com/markwiggles/simple_spree/raw/master/app/assets/images/dsl.png "amex")

```ruby
/ insert_after '#cart-form'

=render 'partials/credit_cards'
```


<h3>Customising Logic</h3>

<h5>Controller Helpers</h5>

To help manage the authentication, we add two helper methods in `applicationHelper.rb`, or where ever you feel appropriate. The methods access the <i>Spree</i> module, `ContollerHelpers`, to get `spree_current_user`.


* `is_admin?` - this can be used as <i>erb</i> text passed as a parameter in the <i>Deface override</i> file. 
* `require_login` - can be used as a `before_filter` (in controllers) for pages in the main website which will need authorisation i.e. using the devise authentication provided with the Spree Application.


```ruby
include Spree::Core::ControllerHelpers

  def is_admin?
    if spree_current_user
      spree_current_user.has_spree_role?('admin')
    end
  end

  def require_login
    if spree_current_user
      unless spree_current_user.has_spree_role?('admin')
        redirect_to spree_login_path
      end
    else
      redirect_to spree_login_path
    end
  end
```
<br>


<h5>Decorators</h5>

Internal Spee code can be extended and overriden by creating files in relevant app/models/spree or app/controllers/spree directory with a .decorator extension.

For example in `orders_controller_decorator.rb` in the controllers directory, we can write code to add a method to display in a Shoppping Cart view.  The method makes use on a controller helper (current_order) to lookup the item count. 


```ruby
Spree::OrdersController.class_eval do

  include Spree::Core::ControllerHelpers
 
  def add_message

   current_order.item_count < 2 ? "10% discount for orders of 2 or more" : "Checkout now for fast delivery"
  
  end

  helper_method :add_message
end
```
More information can be found in the guides under [Logic Customization](https://guides.spreecommerce.com/developer/logic.html)

<br>

<h3>More.....</h3>


<h5>Spree API</h5>
The Spree installation comes bundled with the Spree API which can be used to access the resources of the Spree app.  A key can be generated through the Spree admin backend. Access is at user level, with the same level of permissions.

You can easily test the API locally, by constructing a url with your server address, api path, plus your token which can also be named as api_key. 

```
http://localhost:3000/shop/api/products?token=<your token>
```
A successful GET call should result in a json response.

More information can be found in the guides under [Storefront API](https://guides.spreecommerce.com/api/summary.html).



<h5>Spree with Ember</h5>

The Spree API allows building Client-Side MVC access and a working Spree with Ember Application can be found in this Github repo by [nebulab](https://github.com/nebulab/spree-ember-example), which has a basic demo application and tutorial at the Nebulab website - Using Ember.js with Spree](http://nebulab.it/blog/using-ember-js-with-spree).







