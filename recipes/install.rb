#
# Cookbook Name:: snort
# Recipe:: default
#
# Copyright 2010-2015, Chef Software, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when 'debian'

  snort_package = case node['snort']['database']
                  when 'none'
                    'snort'
                  when 'mysql'
                    'snort-mysql'
                  when 'postgresql', 'pgsql', 'postgres'
                    'snort-pgsql'
                  end

  directory '/var/cache/local/preseeding' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end

  template '/var/cache/local/preseeding/snort.seed' do
    source 'snort.seed.erb'
    owner 'root'
    group 'root'
    mode '0755'
    notifies :run, 'execute[preseed snort]', :immediately
  end

  execute 'preseed snort' do
    command 'debconf-set-selections /var/cache/local/preseeding/snort.seed'
    action :nothing
  end

  package snort_package do
    action :install
  end

  package 'snort-rules-default' do
    action :install
  end

when 'rhel', 'fedora'
  # TODO: I'd like to be able to pull these from a repo, but at least
  # since this is separate from the configuration and service,
  # I can work around it in a site-cookbook

  daq_rpm = "daq-#{node['snort']['rpm']['daq_version']}.x86_64.rpm"

  remote_file "#{Chef::Config[:file_cache_path]}/#{daq_rpm}" do
    source "https://www.snort.org/downloads/snort/#{daq_rpm}"
    checksum node['snort']['rpm']['daq_checksum']
    mode '0644'
  end

  yum_package 'daq' do
    source "#{Chef::Config[:file_cache_path]}/#{daq_rpm}"
    action :install
  end

  snort_rpm = "snort-#{node['snort']['rpm']['version']}.x86_64.rpm"

  remote_file "#{Chef::Config[:file_cache_path]}/#{snort_rpm}" do
    source "https://www.snort.org/downloads/snort/#{snort_rpm}"
    checksum node['snort']['rpm']['checksum']
    mode '0644'
  end

  yum_package 'snort' do
    source "#{Chef::Config[:file_cache_path]}/#{snort_rpm}"
    action :install
  end
end
