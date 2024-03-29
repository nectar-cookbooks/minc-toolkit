#
# Cookbook Name:: minc-toolkit
# Recipe:: default
#
# Copyright (c) 2013, The University of Queensland
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# * Neither the name of the The University of Queensland nor the
# names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE UNIVERSITY OF QUEENSLAND BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
prefix = node.default['minc-toolkit']['prefix'] || '/usr/local'
bin = "#{prefix}/bin"
if File::exists?("#{bin}/dcm2mnc") then
  log "Minc tools already installed in #{bin}" do
    level :info
  end
  if ! node['minc-toolkit']['force_install'] then
    return
  end
end

pf = node['platform_family'] 
case pf
when 'rhel', 'fedora'
  deps = [ 'tar', 'gcc-c++', 'make', 'bison', 'flex', 
           'netcdf', 'netcdf-devel', 'hdf5', 'hdf5-devel',
           'zlib', 'zlib-devel']
  build_from_source = true
when 'debian'
  # Todo ... it would be nice to have 'build from source' support for 
  # debian / ubuntu 
  build_from_source = false
  pkg = 'minc-tools'
else 
  raise "Platform family #{pf} not supported"
end

if ! build_from_source 
  package pkg do
  end
else
  deps.each do |pkg|
    package pkg do
    end
  end 
  
  #
  # Until the Github version's build has stabilized, use a source tgz 
  # from the BIC "packages" server.
  #
  url = node.default['minc-toolkit']['download_url']
  build_dir = node.default['minc-toolkit']['build_dir'] || '/tmp/minc-build'
  
  directory build_dir do
  end
  
  remote_file "#{build_dir}/minc.tar.gz" do
    source url
    use_conditional_get true
  end
  
  bash 'unpack' do
    code 'tar xfz minc.tar.gz --strip-components=1'
    cwd build_dir
  end
  
  bash 'clean' do
    code 'make distclean'
    cwd build_dir
    only_if { File.exists?("#{build_dir}/Makefile") }
  end
  
  bash 'build' do
    code "./configure --prefix=#{prefix} && make && make install"
    cwd build_dir
  end
  
  if node['minc-toolkit']['clean_after_install'] then
    bash 'remove build dir' do
      code "rm -rf #{build_dir}"
    end
  end
end
