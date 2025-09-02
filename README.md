

-----

-----

# my\_robot\_cartographer

ROS2 Humbleと北陽電機製LiDAR (UST-30LX) を使用してCartographer SLAMを実行するためのROS2パッケージです。

## 📝 概要

このリポジトリは、ROS2 Humble環境で北陽LiDAR (`urg_node2`) とCartographer (`cartographer_ros`) を連携させ、2D-SLAM（地図作成と自己位置推定）を行うための設定ファイル一式を提供します。

## 🛠️ 目次

1.  [前提条件](https://www.google.com/search?q=%231-%E5%89%8D%E6%8F%90%E6%9D%A1%E4%BB%B6)
2.  [インストールとビルド](https://www.google.com/search?q=%232-%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%A8%E3%83%93%E3%83%AB%E3%83%89)
3.  [設定](https://www.google.com/search?q=%233-%E8%A8%AD%E5%AE%9A)
4.  [実行方法](https://www.google.com/search?q=%234-%E5%AE%9F%E8%A1%8C%E6%96%B9%E6%B3%95)
5.  [パッケージ構成](https://www.google.com/search?q=%235-%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E6%A7%8B%E6%88%90)
6.  [参考サイト](https://www.google.com/search?q=%236-%E5%8F%82%E8%80%83%E3%82%B5%E3%82%A4%E3%83%88)

-----

## 1\. 前提条件

  * **OS**: Ubuntu 22.04
  * **ROS2**: Humble Hawksbill
  * **ハードウェア**: 北陽電機 UST-30LX (または同等のURGシリーズLiDAR)
  * **ソースコード**: `~/ros2_ws/src` ディレクトリ内に `my_robot_cartographer` と `urg_node2` のソースコードが配置済みであること。

-----

## 2\. インストールとビルド

### ステップ 1: 必要なROS2パッケージのインストール

SLAMの実行と地図保存に必要となる関連パッケージをインストールします。

```bash
sudo apt update
sudo apt install -y ros-humble-cartographer ros-humble-cartographer-rviz
sudo apt install -y ros-humble-navigation2 ros-humble-nav2-bringup
sudo apt install -y ros-humble-tf2-ros
```

### ステップ 2: ワークスペースのビルド

ソースコードが配置されているワークスペースをビルドします。

```bash
cd ~/ros2_ws
colcon build --symlink-install
```

-----

## 3\. 設定

SLAMを実行する前に、LiDARとPCのネットワーク設定が必要です。

  * **LiDAR側の設定**

      * **アドレス**: `192.168.0.15`
      * **ネットマスク**: `255.255.255.0`

  * **PC (ROS2マシン) 側の設定**

      * **アドレス**: `192.168.0.10`
      * **ネットマスク**: `255.255.255.0`

> **Note**: 上記IPアドレスは `launch/hokuyo_cartographer.launch.py` 内で指定されています。もし異なるIPを使用する場合は、Launchファイル内の `ip_address` パラメータを修正してください。

-----

## 4\. 実行方法

### 4.1. SLAMの開始

ビルドしたワークスペースの環境設定を読み込み、Launchファイルを実行します。

```bash
source ~/ros2_ws/install/setup.bash
ros2 launch my_robot_cartographer hokuyo_cartographer.launch.py
```

RVizが起動し、LiDARを動かすとリアルタイムで地図が生成されます。

### 4.2. 地図の保存

SLAMが完了したら、新しいターミナルを開いて以下のコマンドで地図を保存します。

```bash
source ~/ros2_ws/install/setup.bash
ros2 run nav2_map_server map_saver_cli -f ~/map
```

ホームディレクトリに `map.pgm` (画像) と `map.yaml` (メタデータ) が保存されます。

-----

## 5\. パッケージ構成

```
my_robot_cartographer/
├── config
│   └── hokuyo_cartographer.lua  # Cartographerのパラメータ設定
├── launch
│   └── hokuyo_cartographer.launch.py  # LiDAR, TF, Cartographer, RVizを起動
├── package.xml                  # パッケージ情報
├── resource
│   └── my_robot_cartographer
└── setup.py                     # インストール設定
```

-----

## 6\. 参考サイト

  * [ROS2 humble + RPLiDAR A1 + cartographer でSLAMする](https://qiita.com/tomtomApp/items/8d29a2dd00e60dade9e8)
  * [ROS2 humble Cartographer で 2D SLAM！(Docker)](https://qiita.com/porizou1/items/4ddeb5a0aa6c62a4c294)



\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
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


