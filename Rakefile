# encoding: ascii-8bit

# Copyright 2022 Ball Aerospace & Technologies Corp.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# Modified by OpenC3, Inc.
# All changes Copyright 2022, OpenC3, Inc.
# All Rights Reserved

PLUGIN_NAME = Dir['*.gemspec'][0].split('.')[0..-2].join('.')

task :require_version do
  unless ENV['VERSION']
    puts "VERSION is required: rake <task> VERSION=X.X.X"
    exit 1
  end
end

task :build => [:require_version] do
  _, platform, *_ = RUBY_PLATFORM.split("-")
  if platform == 'mswin32' or platform == 'mingw32'
    puts "Warning: Building gem on Windows will lose file permissions"
  end
  system("gem build #{PLUGIN_NAME}")
end
