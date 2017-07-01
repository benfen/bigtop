# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class bigtop_toolchain::jdk {
  case $::operatingsystem {
    /Debian/: {
      require apt
      unless $os[release][major] > "8" {
         require apt::backports
      }

      package { 'openjdk-8-jdk' :
        ensure => present,
      }
    }
    /Ubuntu/: {
      include apt

      package { 'openjdk-8-jdk' :
        ensure  => present,
        # needed for 14.04 
        require => [ Apt::Ppa[ 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu'], Class['apt::update'] ]
      }

      apt::key { 'openjdk-ppa':
        id     => 'eb9b1d8886f44e2a',
        server => 'keyserver.ubuntu.com'
      }  ->
      apt::ppa { 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu':  }
    }
    /(CentOS|Amazon|Fedora)/: {
      package { 'java-1.8.0-openjdk-devel' :
        ensure => present
      }
      if ($::operatingsystem == "Fedora") {
        file { '/usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/cacerts':
          ensure => 'link',
          target => '/etc/pki/java/cacerts'
        }
      }
    }
    /OpenSuSE/: {
      package { 'java-1_8_0-openjdk-devel' :
        ensure => present
      }
    }
  }
}
