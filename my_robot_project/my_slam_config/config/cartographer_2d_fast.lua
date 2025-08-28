-- map_builder.lua: マップ全体の構築方法（サブマップの結合やループクロージャなど）を定義した、基本的な設定ファイルを読み込みます。
include "map_builder.lua"
-- trajectory_builder.lua: 一本の軌跡（ロボットの移動経路とサブマップ）をどう作るかを定義した、基本的な設定ファイルを読み込みます。
include "trajectory_builder.lua"

options = {
  -- 上記で読み込んだマップ構築の設定（MAP_BUILDERテーブル）を使用します。
  map_builder = MAP_BUILDER,
  -- 上記で読み込んだ軌跡作成の設定（TRAJECTORY_BUILDERテーブル）を使用します。
  trajectory_builder = TRAJECTORY_BUILDER,

  -----------------------------------------
  -- === 基本的な座標フレームの設定 ===
  -----------------------------------------
  map_frame = "map",
  tracking_frame = "laser",
  published_frame = "laser",
  odom_frame = "odom",
  provide_odom_frame = true,
  publish_frame_projected_to_2d = true,

  -----------------------------------------
  -- === 使用するセンサーデータの設定 ===
  -----------------------------------------
  use_odometry = false,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 1,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 0,

  -----------------------------------------
  -- === データ処理と配信頻度の設定 ===
  -----------------------------------------
  -- センサーデータに対応する座標変換(tf)を待つ最大時間（秒）。
  -- [推奨範囲: 0.05 ～ 0.5]
  -- [設定のヒント]: 小さくしすぎるとデータ破棄が多くなり、大きくしすぎるとSLAM全体の遅延が大きくなります。
  lookup_transform_timeout_sec = 0.1,
  
  -- サブマップ（地図の断片）をRVizなどに配信する頻度（秒）。
  -- [推奨範囲: 0.05 ～ 1.0] (PC性能による)
  -- [設定のヒント]: 値が小さいほどRVizでの見た目の更新が滑らかになりますが、PC負荷は上がります。
  submap_publish_period_sec = 0.1,
  
  -- 推定したロボットの姿勢を配信する頻度（秒）。
  -- [推奨範囲: 0.05 ～ 1.0] (PC性能による)
  -- [設定のヒント]: これも小さいほどRVizでの表示が滑らかになります。
  pose_publish_period_sec = 0.1,
  
  -- 作成した軌跡全体を配信する頻度（秒）。
  -- [推奨範囲: 1.0 ～ 30.0]
  -- [設定のヒント]: 軌跡全体はデータ量が多いため、あまり頻繁に更新する必要はありません。
  trajectory_publish_period_sec = 1,

  -----------------------------------------
  -- === 各センサーデータのサンプリング設定 ===
  -----------------------------------------
  -- LiDARのデータをどのくらいの割合で処理に使うか。(1.0 = 100%)
  -- [推奨範囲: 0.1 ～ 1.0]
  -- [設定のヒント]: PC負荷が高すぎる場合に値を小さくしますが、通常は1.0でOKです。
  rangefinder_sampling_ratio = 1.,
  
  -- (以下のパラメータは、対応するセンサーを'use_... = false'にしているため、現在SLAMの動作に影響を与えません)
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 0.1,
  imu_sampling_ratio = 0.1,
  landmarks_sampling_ratio = 0.1,
}

-----------------------------------------
-- === 読み込んだ基本設定の上書き ===
-----------------------------------------
-- 2D SLAMを実行するように、マップビルダーに指示します。(true/false)
MAP_BUILDER.use_trajectory_builder_2d = true
-- IMU（慣性計測装置）のデータを使用しないように、2D軌跡ビルダーに指示します。(true/false)
TRAJECTORY_BUILDER_2D.use_imu_data = false

-----------------------------------------
-- ##### 安全な高精度化のための設定変更 #####
-----------------------------------------

-- Tip 1: 処理するレーザー点の数を減らし、計算速度を優先する (Voxel Filter)
-- [設定のヒント]: 高速移動時はリアルタイム性が重要です。値を少し大きくして計算負荷を下げます。
TRAJECTORY_BUILDER_2D.voxel_filter_size = 0.12

-- Tip 2: 自己位置推定の探索範囲を調整する
-- [設定のヒント]: 現在の0.3mは広いのでそのままでも良いですが、ロボットの性能に合わせて調整します。
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.linear_search_window = 0.1

-- [設定のヒント]: 90度は広すぎて、間違った壁と一致してしまう危険性が高いです。
-- ロボットが1スキャンごと（例: 0.1秒）に90度も回転することは稀なため、より現実的な値に狭めます。
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.angular_search_window = math.rad(9.)

-- Tip 3: サブマップをより特徴的にする (← ★追記した項目)
-- [設定のヒント]: 1つのサブマップに含めるスキャン数を増やし、マッチングの安定性を高めます。
TRAJECTORY_BUILDER_2D.submaps.num_range_data = 100

-- ここまで設定した内容（optionsテーブル）をCartographerに渡して返します。
return options
