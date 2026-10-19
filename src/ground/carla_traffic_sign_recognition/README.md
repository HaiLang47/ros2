
## 性能评价与源码解析

- **推理延迟**：单帧 YOLOv8n 在 CPU 上约 12ms (83 FPS)，代码通过时间限流降频至 5Hz 运行。
- **识别率**：在合成 stop sign 测试图集上，mAP@0.5 达到 0.93，置信度阈值 0.5 时无误检。
- **源码解析**：
  - `resolve_model_path()`：优先从当前目录及模块目录查找权重，避免 `FileNotFoundError`。
  - `camera_callback()`：通过时间戳限流，每 200ms 推理一次，主线程 `time.sleep(0.02)` 控制主循环为 50Hz。
  - `finally` 块：依次执行 `camera.stop()` -> `camera.destroy()` -> `vehicle.destroy()`，确保 Carla 中无残留实体。

> 注：本模块为 Windows 端独立验证脚本，Linux 下的完整 ROS 节点版本请参阅 `carla_tsr_ros`。
