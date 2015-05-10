#
# Cookbook Name:: heartbeat
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

src_filepath=node['pacemaker']['src_filepath']
extract_path=node['pacemaker']['extract_filepath']
repo_filename=node['pacemaker']['repo_filename']
rpm_packages=node['pacemaker']['rpm_packages']

# install wget
%w{wget}.each do |pkg|
  package pkg do
    action :install
  end
end

# get HA repository configuration file
remote_file src_filepath do
  source "http://en.sourceforge.jp/frs/redir.php?m=jaist&f=%2Flinux-ha%2F61791%2Fpacemaker-1.0.13-2.1.el6.x86_64.repo.tar.gz"
end

# extract HA repository file
bash 'extract_src_file' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar zxf #{src_filepath} -C #{extract_path}
    cp -iv #{extract_path}/#{repo_filename} /etc/yum.repos.d/#{repo_filename}
    EOH
  not_if { ::File.exists?(extract_path)}
end

# set HA repository file
template "/etc/yum.repos.d/"+repo_filename do
  source "pacemaker.repo.erb"
  owner "root"
  group "root"
  mode "644"
end

# install heartbeat
# %w{pacemaker.x86_64 heartbeat.x86_64 pm_extras.x86_64}.each do |pkg|
%w{heartbeat.x86_64}.each do |pkg|
  package pkg do
    action :install
  end
end

# install pacemaker with rpm packages
# rpm -ivh pacemaker-1.0.13-2.el6.x86_64.rpm pacemaker-libs-1.0.13-2.el6.x86_64.rpm libesmtp-1.0.4-16.el6.x86_64.rpm pm_extras-1.5-1.el6.x86_64.rpm
rpm_packages.each do |rpm_package|
  package extract_path+"/rpm/"+rpm_package do
    action :install
  end
end

# create symlink of heartbeat
# ln -s  /usr/lib64/heartbeat/heartbeat /usr/libexec/heartbeat/heartbeat
link "/usr/libexec/heartbeat/heartbeat" do
  to "/usr/lib64/heartbeat/heartbeat"
  link_type :symbolic
end

# add iptables
# iptables -A INPUT -p udp -m udp --dport 694 -j ACCEPT
# service iptables save
#
# - abbreviate this procedure

# set ha.cf file
template "/etc/ha.d/ha.cf" do
  source "ha.cf.erb"
  owner "root"
  group "root"
  mode "644"
end

# set authkeys file
template "/etc/ha.d/authkeys" do
  source "authkeys.erb"
  owner "root"
  group "root"
  mode "600"
end

# start heartbeat
service "heartbeat" do
    action [ :start ]
end
