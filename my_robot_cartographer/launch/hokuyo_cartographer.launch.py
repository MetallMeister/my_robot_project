import os
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    # ご自身のパッケージ名
    my_package_name = 'my_robot_cartographer' 

    # RViz設定ファイルのパス
    # システムにインストールしたcartographer_rosパッケージ内のものを参照
    rviz_config_file = os.path.join(
            get_package_share_directory('cartographer_ros'),
            'rviz',
            'cartographer.rviz')

    # Cartographer設定ファイル（lua）のパス
    cartographer_config_dir = os.path.join(get_package_share_directory(my_package_name), 'config')
    configuration_basename = 'hokuyo_cartographer.lua'

    return LaunchDescription([
        # 1. Hokuyo LiDARを起動するノード
        Node(
            package='urg_node2',
            executable='urg_node2_node',
            name='urg_node',
            output='screen',
            parameters=[{'laser_frame_id': 'laser'}] 
        ),

        # 2. base_linkとlaser間の静的な座標変換
        Node(
            package='tf2_ros',
            executable='static_transform_publisher',
            name='static_transform_publisher',
            output='screen',
            arguments=['0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 'base_link', 'laser']
        ),

        # 3. Cartographer本体のノード
        Node(
            package='cartographer_ros',
            executable='cartographer_node',
            name='cartographer_node',
            output='screen',
            parameters=[{'use_sim_time': False}],
            arguments=['-configuration_directory', cartographer_config_dir,
                       '-configuration_basename', configuration_basename],
        ),

        # 4. Occupancy Grid（占有格子地図）を生成するノード
        Node(
            package='cartographer_ros',
            executable='cartographer_occupancy_grid_node',
            name='cartographer_occupancy_grid_node',
            output='screen',
            parameters=[{'use_sim_time': False}],
            arguments=['-resolution', '0.05', '-publish_period_sec', '1.0']
        ),

        # 5. RVizを起動するノード
        Node(
            package='rviz2',
            executable='rviz2',
            name='rviz2',
            arguments=['-d', rviz_config_file],
            output='screen'
        )
    ])
