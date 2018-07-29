# SpreeCustomerSegmentation

## Demo

Try Spree Customer Segmentation for Spree master with direct deployment on Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/vinsol-spree-contrib/spree-demo-heroku/tree/spree_customer_segmentation_master)

## Introduction

Knowing who your customers are, what your customers want, their spending habits, etc can provide invaluable information to any store.   
With Vinsol's [spree_customer_segmentation](https://github.com/vinsol-spree-contrib/spree_customer_segmentation), you can have all that information within seconds.  

**This extension currently supports Spree > 3.1, Rails > 5, Mysql and Postgresql Database.**

## Usage

There are seven categories -

1. Order
2. Cart
3. Purchase
4. Session
5. Address
6. Product
7. User Info and Demographics

Each categories have their own metrics.

![filter-image](https://user-images.githubusercontent.com/8337530/43099223-1c48f106-8edf-11e8-860b-f440899c4a01.png)

You can select any metric, choose the appropriate operator, and enter input values, against which you want to filter out the user data.

![filter-selected](https://user-images.githubusercontent.com/8337530/43098845-ef18716c-8edd-11e8-827d-9950d6ffef7c.png)

**Add multiple values**  
You can add multiple inputs by pressing enter after one completing one input.

**Product Autocomplete functionality**  
While applying product based filters, you need to enter few characters, and the use the product autocomplete
functionality to select the desired product.

![product-autocomplete](https://user-images.githubusercontent.com/8337530/43098863-fcbb2206-8edd-11e8-87db-5ec3da32b1ed.png)

**Multiple Filters**  
You can apply any number of filters, one after one, and get in depth analysis of your store data.

![multiple-filters](https://user-images.githubusercontent.com/8337530/43098830-e2cfaede-8edd-11e8-9630-4a7eaee5f9dd.png)

**Save the segments**

You can save the created segments, by simply clikcing the save button, and entering the desired segment name.

**Export the segments**

You can export the segments in CSV format. As soon as you click on the export button, a mail containing the CSV is delivered to the currently logged in admin user.

> Note: You need to add the mailer settings for export functionality to work.


## Additional Information

* Filters

| Filter  | Category  | Details  | Accepts Value |
|---|---|---|---|---|---|
| Days From First Order | Order| Number of days from first order  | Positive integers |
| Days From Last Order | Order| Number of days from last order | Positive integers |
| Order Quantity Total | Order| Sum of quantity of all ordered items | Positive integers |
| Total Number Of Order | Order| Total number of orders placed | Positive integers |
| Order Quantity Average | Order| Average quantity of items per order | Positive numbers |
| Order Frequency | Order| Number of orders per 30 days. Formula: (No of orders * 30)/(Days From Registration) | Positive numbers |
| Revenue | Order| Sum of total of all orders placed | Positive numbers |
| Number Of Order In Cart | Cart| Total number of items inside the cart | Positive integers |
| Days From First Order | Order| Number of days from first order  | Positive integers |
| Days From First Order | Order| Number of days from first order  | Positive integers |
| Used A Coupon | Purchase | Users who have used a coupon or not  | Boolean |
| Coupon Last Used | Purchase | Date when a user last applied a coupon | Date (YYYY-MM-DD) |
| Number Of Sessions | Session | Number of time user has logged in | Positive integers |
| Last Active Session | Session| Date when a user was last active  | Date (YYYY-MM-DD) |
| Billing Address | Address | Complete concatenated billing address | Text |
| Billing City | Address | - | Text |
| Billing State | Address | -  | Text |
| Billing Zipcode | Address | - | Text |
| Shipping Address | Address | Complete concatenated shipping address | Text |
| Shipping City | Address | - | Text |
| Shipping State | Address | - | Text |
| Shipping Zipcode | Address | - | Text |
| First Name | User info and gemographics | - | Text |
| Last Name | User info and gemographics | - | Text |
| Email | User info and gemographics | - | Text |
| Phone | User info and gemographics | - | Text |
| Days From Registration | User info and demographics| Number of days from registration  | Positive integers |
| Products Ordered | Product | Products ordered by users | Product names |
| Products Added To Cart | Product | Products added to cart by users | Product names |
| Products Recently Ordered | Product | Product ordered by users in last 7 days | Product names |
| Products Recently Added To Cart | Products | Products added to cart by users in last 7 days | Product names |
| New Products Ordered | Product | Products which were added in last 7 days and ordered by users | Product names |
| New Products Added To Cart | Product | Products which were added in last 7 days and  added to cart by users | Product names |


* Operators

| Operator  | Details  |
|---|---|
| includes | Return records which exactly matches the value user entered |
| not includes | Return records which do not exactly match the value user entered |
| includes all | Return records which exactly matches the all the values user entered |
| contains | Return records which matches (substring) the value user entered |
| does not contain | Return records which do not match (substring) the value user entered |
| starts with | Return records which starts with the value user entered |
| blank | Return records which do not / do have the required data, depending on user's value (boolean) |
| >= | Return records which have data greater than or equal to the value user entered |
| > | Return records which have data greater than the value user entered |
| = | Return records which have data equal to the value user entered |
| not equals to | Return records which have data not equal to the value user entered |
| < | Return records which have data less than the value user entered |
| <= | Return records which have data less than or equal to the value user entered |
| after | Return records which have date after the value user entered |
| before | Return records which have date before the value user entered |
| equals | Return records which have required data or not, depending on user's value (boolean) |

## Installation

1. Add this extension to your Gemfile with this line:
  ```ruby
  gem 'spree_customer_segmentation', github: 'vinsol-spree-contrib/spree_customer_segmentation'
  ```

2. Install the gem using Bundler:
  ```ruby
  bundle install
  ```

3. Copy & run migrations
  ```ruby
  bundle exec rails g spree_customer_segmentation:install
  ```

4. Restart your server

  If your server was running, restart it so that it can find the assets properly.

## Testing

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_customer_segmentation/factories'
```


## Contributing

  1. [Fork](https://help.github.com/articles/fork-a-repo) the project.
  2. Create a new branch, and add your changes.
  3. Add tests cases.
  4. Create a [pull request](https://help.github.com/articles/using-pull-requests).


## Credits

[![vinsol.com: Ruby on Rails, iOS and Android developers](http://vinsol.com/vin_logo.png "Ruby on Rails, iOS and Android developers")](http://vinsol.com)

Copyright (c) 2018 [vinsol.com](http://vinsol.com "Ruby on Rails, iOS and Android developers"), released under the New MIT License
