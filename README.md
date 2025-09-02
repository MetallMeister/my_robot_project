北陽lidar 30lxのipを固定する　
アドレス=192.168.0.15 ネットマスク=255.255.255.0 ゲートウェイ=192.168.0.1

参考サイト
https://qiita.com/tomtomApp/items/8d29a2dd00e60dade9e8
https://qiita.com/porizou1/items/4ddeb5a0aa6c62a4c294

変更点
launchファイルの所々の名前の変更
setupファイルの追記変更（launchとconfigの追記のため）
luaファイルは上記のサイトを参考に高速化とコートサイズへの最適化の変更

必要なもの
sudo apt install ros-humble-cartographer 
sudo apt install ros-humble-cartographer-rviz
地図制作とrviz2で使用

sudo apt install ros-humble-navigation2
sudo apt install ros-humble-nav2-bringup
地図の保存

起動
ros2 launch my_robot_cartographer hokuyo_cartographer.launch.py
地図保存
ros2 run nav2_map_server map_saver_cli -f ~/map
