import os
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    # あなたが保存したRViz設定ファイルのパスを指定
    rviz_config_file = os.path.join(get_package_share_directory('my_slam_config'), 'config', 'my_slam_view.rviz')

    # SLAMの計算を行うノード
    cartographer_node = Node(
        package='cartographer_ros', 
        executable='cartographer_node', 
        name='cartographer_node', 
        output='screen',
        arguments=[
            '-configuration_directory', os.path.join(get_package_share_directory('my_slam_config'), 'config'),
            '-configuration_basename', 'cartographer_2d.lua'
        ]
    )

    # 計算結果を地図(/map)として配信するノード (←これが抜けていました)
    cartographer_occupancy_grid_node = Node(
        package='cartographer_ros',
        executable='cartographer_occupancy_grid_node',
        name='cartographer_occupancy_grid_node',
        output='screen',
        arguments=['-resolution', '0.05']
    )

    # RViz2を起動するノード
    rviz2_node = Node(
        package='rviz2', 
        executable='rviz2', 
        name='rviz2', 
        output='screen',
        arguments=['-d', rviz_config_file]
    )
    
    return LaunchDescription([
        cartographer_node,
        cartographer_occupancy_grid_node, # ←地図配信用ノードを起動リストに追加
        rviz2_node
    ])
