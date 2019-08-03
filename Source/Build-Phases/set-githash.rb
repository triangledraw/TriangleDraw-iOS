#!/usr/bin/env ruby

# This script obtains the first 7 characters of the commit SHA (hash)
# so it's later possible to determine which revision was used to build a particular product.
#
# Instructions:
# 1. Add this file to your project.
#
# 2. Go to Project settings > target > Build Phases > Run Script. 
#
# 3. Add Shell /bin/sh and a value with the path to this script
#
# 4. Add "githash" as a key to your app's info plist to compile.
#
# 5. Reference the property list with the "githash" key to obtain the git hash value, like this:
# NSString* githash = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"githash"];
#

target_build_dir = ENV["TARGET_BUILD_DIR"]
executable_name  = ENV["EXECUTABLE_NAME"]
project_dir      = ENV["PROJECT_DIR"]
infoplist_file   = ENV["INFOPLIST_FILE"]

absolute_path_to_info_plist = "#{target_build_dir}/#{executable_name}.app/#{infoplist_file}"
puts "absolute_path_to_info_plist #{absolute_path_to_info_plist.inspect}"

absolute_path_to_plistbuddy = "/usr/libexec/PlistBuddy"

githash = "NONE"
Dir.chdir(project_dir) do
	githash = `git rev-parse --short HEAD`
	githash.strip!
end

puts "githash #{githash.inspect}"

cmd = "#{absolute_path_to_plistbuddy} -c \"Set githash #{githash}\" \"#{absolute_path_to_info_plist}\""
puts "running command #{cmd.inspect}"
system(cmd)
