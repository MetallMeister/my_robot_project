-- 安全な高精度版 Cartographer 2D SLAM 設定

include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "map",
  tracking_frame = "laser",
  published_frame = "laser",
  odom_frame = "odom",
  provide_odom_frame = true,
  publish_frame_projected_to_2d = true,
  use_odometry = false,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 1,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 0,
  lookup_transform_timeout_sec = 0.1,
  submap_publish_period_sec = 0.01,
  pose_publish_period_sec = 0.01,
  trajectory_publish_period_sec = 0.01,
  rangefinder_sampling_ratio = 1.,
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 1.,
}

MAP_BUILDER.use_trajectory_builder_2d = true
TRAJECTORY_BUILDER_2D.use_imu_data = false

-- ########################################
-- ##### 安全な高精度化のための設定変更 #####
-- ########################################

-- Tip 1: 処理するレーザー点の数を増やす (値を小さくするほど高精度)
-- レーザー点を0.02m (2cm) の立方体ごとに1つにまとめる。より多くの点を使うため計算負荷が上がります。
TRAJECTORY_BUILDER_2D.voxel_filter_size = 0.02

-- Tip 2: 自己位置推定の探索範囲を広げる
-- 現在のスキャンと地図をマッチングさせる際の探索範囲を少し広げ、より良い位置を見つけやすくします。
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.linear_search_window = 0.15
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.angular_search_window = math.rad(25.)

return options
