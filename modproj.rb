require 'xcodeproj'
project = Xcodeproj::Project.open('NetUtils.xcodeproj')
main_target = project.targets.first
phase = main_target.new_shell_script_build_phase("Create ifaddrs module map")
phase.shell_script = "${SRCROOT}/createModuleMap.sh"
project.save()
