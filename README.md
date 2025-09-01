北陽lidar 30lxのipを固定する　
アドレス=192.168.0.15 ネットマスク=255.255.255.0 ゲートウェイ=192.168.0.1

Lidar開始コマンド
source ~/ros2_ws/install/setup.bash && ros2 launch urg_node2 urg_node2.launch.py
Cartographerの実行コマンド
source ~/ros2_ws/install/setup.bash && ros2 launch my_slam_config slam_only_fast.launch.py

ステップ1：SLAMの状態をファイルに保存する
SLAMを実行して地図が完成したら、3つ目の新しいターミナルを開き、以下のコマンドを順番に実行します。

    軌跡の記録を終了するコマンド
    Bash

ros2 service call /finish_trajectory cartographer_ros_msgs/srv/FinishTrajectory "{trajectory_id: 0}"

現在の状態をファイルに書き出すコマンド
Bash

    ros2 service call /write_state cartographer_ros_msgs/srv/WriteState "{filename: '${HOME}/my_map.pbstream', include_unfinished_submaps: true}"

ステップ2：状態ファイルから地図画像を生成する

ステップ1が完了したら、SLAMを停止して構いません。新しいターミナルで以下のコマンドを実行します。
Bash

ros2 run cartographer_ros cartographer_assets_writer -pbstream_filename ~/my_map.pbstream -map_filestem ~/my_map


状態が保存できる
