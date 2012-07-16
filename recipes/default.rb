#
# Cookbook name: magento
# Recipe: default
#

# Define some variables.
project = node['ariadne']['project']
site = "#{project}.dev"

package "php5-mcrypt" do
    action :install
end

bash 'Create Magento database' do
    user "vagrant"
    group "vagrant"
    code <<-EOH
        mysql -u root --password=#{node['mysql']['server_root_password']} -e "CREATE DATABASE IF NOT EXISTS #{project}"
    EOH
end

bash "Download Magento Community Edition 1.7.0.2" do
    user "vagrant"
    group "vagrant"
    cwd "/mnt/www/html"
    code <<-EOH
        wget http://www.magentocommerce.com/downloads/assets/1.7.0.2/magento-1.7.0.2.tar.gz -O #{project}.tar.gz
        tar -xf #{project}.tar.gz
    EOH
end

web_app site do
    port node['apache']['listen_ports'].to_a[0]
    template "sites.conf.erb"
    server_name site
    server_aliases [ "www.#{site}" ]
    docroot "/mnt/www/html/#{project}"
end

bash "Restarting apache" do
    user "root"
    group "root"
    code <<-EOH
        /etc/init.d/apache2 restart
    EOH
end

bash "Installing Magento" do
    user "vagrant"
    group "vagrant"
    cwd "/mnt/www/html/#{project}"
    code <<-EOH
        php -f install.php -- \
          --license_agreement_accepted "yes" \
          --locale "en_CA" \
          --timezone "Etc/GMT+5" \
          --default_currency "CAD" \
          --db_model "mysql4" \
          --db_host "localhost" \
          --db_name "#{project}" \
          --db_user "root" \
          --db_pass "#{node['mysql']['server_root_password']}" \
          --db_prefix "" \
          --session_save "db" \
          --admin_frontname "admin" \
          --url "#{site}" \
          --enable_charts "yes" \
          --skip_url_validation "yes" \
          --use_rewrites "yes" \
          --use_secure "no" \
          --secure_base_url "" \
          --use_secure_admin "no" \
          --admin_firstname "Admin" \
          --admin_lastname "User" \
          --admin_email "admin.user@example.com" \
          --admin_username "admin" \
          --admin_password "admin123"
    EOH
end
