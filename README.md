北陽lidar 30lxのipを固定する　
アドレス=192.168.0.15 ネットマスク=255.255.255.0 ゲートウェイ=192.168.0.1

Lidar開始コマンド
source ~/ros2_ws/install/setup.bash && ros2 launch urg_node2 urg_node2.launch.py
Cartographerの実行コマンド
source ~/ros2_ws/install/setup.bash && ros2 launch my_slam_config slam_only_fast.launch.py
