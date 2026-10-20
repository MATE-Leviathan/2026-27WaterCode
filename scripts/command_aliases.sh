# Aliases are short commands to replace long ones.

alias deploy='~/2026-27WaterCode/scripts/deploy.sh'
alias hwlaunch='ros2 launch controller_node jetson_combined_launch.py'
alias laplaunch='ros2 launch controller_node topside_combined_launch.py'
alias jetson='ssh 10.50.2.103'
alias natbuild='~/2026-27WaterCode/scripts/native_build.sh'
alias rosjet='source ~/2026-27WaterCode/ROSJetsonMaster.sh'
alias rosstd='source ~/2026-27WaterCode/scripts/ROSStandard.sh'
alias simlaunch='roslaunch controller_node 2023_compbot_combined.launch hw_or_sim:=sim joy_or_key:=key button_box:=false'
alias ls='ls --color'
alias foxlaunch='ros2 launch foxglove_bridge foxglove_bridge_launch.xml'
