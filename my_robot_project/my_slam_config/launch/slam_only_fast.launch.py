import os
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node
def generate_launch_description():
    # 保存したRViz設定ファイルのパスを指定
    rviz_config_file = os.path.join(get_package_share_directory('my_slam_config'), 'config', 'my_slam_view.rviz')

    cartographer_node = Node(
        package='cartographer_ros', executable='cartographer_node', name='cartographer_node', output='screen',
        arguments=['-configuration_directory', os.path.join(get_package_share_directory('my_slam_config'), 'config'),'-configuration_basename', 'cartographer_2d_fast.lua']
    )
    rviz2_node = Node(
        package='rviz2', executable='rviz2', name='rviz2', output='screen',
        arguments=['-d', rviz_config_file]
    )
    return LaunchDescription([cartographer_node, rviz2_node])
