**Requirements:**
* Ruby 3.1.1
* Rails 7.0.2.3
* PostgreSQL 13.4
* wkhtmltopdf 0.12.6

**Installation:**

`$ git clone`

`$ bundle i`

`$ bundle e rake db:create`

`$ bundle e rake db:migrate`

`$ bundle e rake db:seed`

`$ bundle e rails s`

You can login as admin with ` admin@example.com ` : ` admin `

**Installation wkhtmltopdf gem on Fedora 35:**


`$ cd /vendor/bundle/ruby/3.1.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/`

`$ ln wkhtmltopdf_centos_8_amd64.gz wkhtmltopdf_fedora_35_amd64.gz`
