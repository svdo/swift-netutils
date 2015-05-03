require 'xcodeproj'
puts ENV['PROJECT_FILE_PATH']
project = Xcodeproj::Project.open(ENV['PROJECT_FILE_PATH'])
main_target = project.targets.first
phase = main_target.new_shell_script_build_phase("Create ifaddrs module map")
phase.shell_script = "do sth with ${SRCROOT}/createModuleMap.sh"
project.save()
