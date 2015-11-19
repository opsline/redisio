#
# Cookbook Name:: redisio
# Recipe:: sentinel_enable
#
# Copyright 2013, Brian Bianco <brian.bianco@gmail.com>
#
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

sentinel_instances = node['redisio']['sentinels']

if sentinel_instances.nil?
  sentinel_instances = [{'sentinel_port' => '26379', 'name' => 'mycluster', 'master_ip' => '127.0.0.1', 'master_port' => '6379'}]
end

sentinel_instances.each do |current_sentinel|
  sentinel_name = current_sentinel['name'] || current_sentinel['port']
  sentinel_name = current_sentinel['sentinel_name'] || "sentinel_#{sentinel_name}"
  resource = resources("service[redis_#{sentinel_name}]")
  resource.action Array(resource.action)
  resource.action << :start
  resource.action << :enable
end
