# 纸间 · 课程 DDL 备忘

一款纸感风格的课程 DDL 便签 Flutter 应用：把作业主题、课程、截止日期、条目清单和参考图片，一笔一划记进一张张便签里。

> 大二移动开发软件课程作业 · 2026 秋季

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter) ![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart) ![Version](https://img.shields.io/badge/version-1.0.0%2B1-black)

---

## ✨ 功能特性

| 功能 | 说明 |
|------|------|
| 🎬 启动动画 | 纸感启动页，图标旋入 + 手绘笔迹逐笔绘制 |
| 🗂️ DDL 卡片列表 | 自动排序：重点置顶 → 未完成优先 → 按截止日期由近到远 |
| 🔍 搜索 | 顶部搜索栏按标题、课程、内容实时过滤，附空结果提示 |
| 📌 重点置顶 | 卡片菜单一键置顶，边框加粗以示强调 |
| ✅ 完成勾选 | 一键切换完成状态，标题划线变灰，顶部实时统计「待完成 N」 |
| ☑️ 条目清单 | 把作业拆成多个待办逐项打勾，卡片上显示完成进度条 |
| 📅 DDL 日期 | 日期选择器设置截止日，自动显示「还剩 X 天 / 今天截止 / 明天截止 / 已逾期 X 天」 |
| 🖼️ 图片记录 | 从相册选择参考图或作业截图，详情可双指缩放（1x–5x） |
| ✍️ 新增 / 编辑 | 新增与编辑共用同一套编辑器，保存后即时刷新列表 |
| 🗑️ 删除 | 卡片菜单删除便签，SnackBar 提示结果 |
| 🤎 纸感视觉 | 米色纸张底色 + 深墨色文字 + 手绘分隔线，Material 3 |

## 📱 界面结构

```
启动页 (SplashPage)
  └─ 首页 (HomePage)
       ├─ 顶部标题 + 「待完成 N」统计
       ├─ 搜索栏（课程 / 主题 / 内容）
       ├─ 置顶提示条
       ├─ DDL 卡片列表（置顶 / 完成 / 日期排序）
       │    └─ 点击卡片 → 编辑便签 (NoteEditorPage)
       └─ 右下角悬浮按钮 → 新增便签 (NoteEditorPage)

编辑页 (NoteEditorPage)
  ├─ 主题概要（必填）
  ├─ 课程名称
  ├─ DDL 日期（日期选择器）
  ├─ 详细记录（多行文本）
  ├─ 条目清单（增删条目 + 逐项打勾）
  ├─ 图片记录（相册选择 / 更换 / 移除）
  └─ 底部操作栏 [插入图片 | 完成]

图片页 (ImageZoomPage) — 从编辑页点击图片进入，支持双指缩放
```

## 🛠️ 技术栈

- **Flutter**（Material 3）— UI 框架，全部页面与主题自定义
- **image_picker** — 从系统相册选择图片（限制最大 2048px、质量 90）
- **dart:io** — 读取本地图片文件
- **CustomPainter** — 启动页手绘笔迹动画
- 状态管理：`StatefulWidget` + `setState`（无第三方状态库）
- 无后端服务，纯前端单机应用

## 📂 项目结构

```
course_ddl/
├── lib/
│   └── main.dart          # 入口、主题、数据模型、全部页面与组件
├── android/
├── ios/
└── pubspec.yaml
```

`main.dart` 内部按职责分为：

| 区块 | 内容 |
|------|------|
| `AppColors` / `CourseDdlApp` | 纸感配色与全局主题 |
| `DdlNote` / `CheckItem` | 便签与条目数据模型 |
| `SplashPage` / `SketchLinePainter` | 启动页与手绘线动画 |
| `HomePage` / `DdlCard` | 首页列表、搜索、排序与卡片 |
| `NoteEditorPage` / `_SectionTitle` | 新增 / 编辑便签 |
| `ImageZoomPage` | 图片缩放查看 |
| `formatDate` / `dueLabel` | 日期格式化与 DDL 倒计时文案 |

## 🚀 快速开始

### 环境要求

- Flutter SDK `>= 3.0.0`（本项目环境为 `^3.13.3`）
- Dart SDK `>= 3.0.0 < 4.0.0`
- Android Studio / VS Code + Flutter 插件
- Android 真机（开启 USB 调试）或模拟器

### 运行项目

```bash
# 1. 进入项目目录
cd course_ddl

# 2. 安装依赖
flutter pub get

# 3. 查看可用设备
flutter devices

# 4. 运行到设备
flutter run
```

### 构建 APK

```bash
# 开发调试包（体积较大）
flutter build apk --debug

# Release 正式包（推荐）
flutter build apk --release

# 产物位置
# build/app/outputs/flutter-apk/app-release.apk
```

### 安装到手机

```bash
# 方式 A：直接用 flutter run（最方便，有热重载）
flutter run

# 方式 B：把 APK 文件传到手机，点击安装
#   1. 数据线连接手机
#   2. 手机上开启「USB 文件传输」
#   3. 复制 build/app/outputs/flutter-apk/app-release.apk 到手机
#   4. 手机文件管理器里点击安装
```

## 📦 Releases

每个版本的 APK 构建产物保存在本地 `releases/vX.Y.Z/` 目录中，**不会被提交到 Git**（已在 `.gitignore` 中忽略）。

发布新版本时：
1. 更新 `pubspec.yaml` 中的 `version: X.Y.Z+buildNumber`
2. 构建：`flutter build apk --release`
3. 重命名 APK 放到 `releases/vX.Y.Z/` 目录
4. GitHub 网页端 → Releases → Draft a new release → 上传 APK

## 💾 数据说明

当前版本的便签数据保存在**应用内存**中，并内置 3 条示例便签（本地存储作业 / 数据结构练习 / 英语阅读打卡）：

- 退出应用后再次打开，会恢复为初始示例数据
- 新增、编辑、删除、置顶与完成状态均不持久化
- 后续计划：使用 JSON 文件 + 应用私有目录实现本地持久化

## 📄 说明

本项目为课程作业作品，仅用于学习与演示。
