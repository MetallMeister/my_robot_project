import os
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node
def generate_launch_description():
    cartographer_node = Node(
        package='cartographer_ros', executable='cartographer_node', name='cartographer_node', output='screen',
        arguments=['-configuration_directory', os.path.join(get_package_share_directory('my_slam_config'), 'config'),'-configuration_basename', 'cartographer_2d.lua']
    )

    # rviz2を、設定ファイル(-d)なしで、まっさらに起動する
    rviz2_node = Node(
        package='rviz2', executable='rviz2', name='rviz2', output='screen'
    )
    
    return LaunchDescription([cartographer_node, rviz2_node])
