#
# Cookbook Name:: snort
# Attributes:: default
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

# See conf.rb for setting of home_net and other vars
case node['platform_family']
when 'debian'
  # nothing to see here, move along
when 'rhel'

  default['snort']['service_name']        = 'snortd'
  default['snort']['rpm']['daq_version']  = '2.0.6-1.centos7'
  default['snort']['rpm']['daq_checksum'] = '9e3a45d6b265d3cc7868220eb9152a73803adda7829f150f7c8b5d707c6b4c43'
  default['snort']['rpm']['version']      = '2.9.7.6-1.centos7'
  default['snort']['rpm']['checksum']     = '1673fd01f7344cbdd100b7765bfd83663cdd0367097c73ff133dfa998d1b6a46'
when 'fedora'
  default['snort']['rpm']['daq_version']  = '2.0.6.F21'
  default['snort']['rpm']['daq_checksum'] = '698c31e5381d572e3b43c922e2471acdfe1027c0c545abdb7d0a5dd751198ffd'
  default['snort']['rpm']['version']      = '2.9.7.5-1.f21'
  default['snort']['rpm']['checksum']     = '021e8755edbfebd1fdfe5e61bfbf91055be052331a0b3e25f76be4fb816e51ad'
end

default['snort']['database'] = 'none'
