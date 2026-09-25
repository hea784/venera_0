<div align="center">

# Venera (hea784 fork)

**上游 [venera-app/venera](https://github.com/venera-app/venera) 已停止维护，本仓库在其基础上持续维护 —— 专注 Android 体验：网络增强、稳定性修复、全量汉化、更舒服的阅读功能**

A maintained fork of [Venera](https://github.com/venera-app/venera), a comic reader supporting local and network comics — with Android-first improvements and signed APK releases.

[![Build Android APK](https://github.com/hea784/venera_0/actions/workflows/build-android.yml/badge.svg)](https://github.com/hea784/venera_0/actions/workflows/build-android.yml)
[![Release](https://img.shields.io/github/v/release/hea784/venera_0)](https://github.com/hea784/venera_0/releases)
[![License](https://img.shields.io/github/license/hea784/venera_0)](LICENSE)
[![Flutter](https://img.shields.io/badge/flutter-3.41.4-02569B?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-Android%206%2B-3DDC84?logo=android&logoColor=white)](https://github.com/hea784/venera_0/releases)
[![Upstream](https://img.shields.io/badge/upstream-venera--app%2Fvenera-8A2BE2)](https://github.com/venera-app/venera)

**[📥 下载安装包](https://github.com/hea784/venera_0/releases/latest)** · [从源码构建](#-从源码构建) · [从官方版迁移](#️-从官方版迁移到本-fork重要) · [创建漫画源](doc/comic_source.md)

</div>

---

## ✨ 本 fork 增强了什么

### 🆕 新功能（借鉴 [Mihon](https://github.com/mihonapp/mihon) / [Kotatsu](https://github.com/KotatsuApp/Kotatsu) 等优秀阅读器）

| 功能 | 说明 |
|---|---|
| 🌙 **夜间滤光** | 阅读器可叠加黑色遮罩降低画面亮度，强度 5%–80% 连续可调，保护夜间观感，无需依赖系统亮度；支持漫画级 / 设备级设置 |
| 📊 **阅读统计** | 已读漫画数、已读章节数、活跃天数，以及近 30 天每日阅读柱状图；入口在「历史」页右上角 |
| 🔍 **历史搜索** | 历史页新增标题关键词搜索，漫画多了也能快速找到 |
| 🖼 **页面显示方式** | 竖长漫画可选「完整显示 / 铺满宽度 / 填充裁切」，不再只能两侧留白 |

### 🌐 网络增强（相对上游）

- **弱网自动重试**：对所有漫画源透明地重试瞬时网络错误（连接超时、连接重置、服务器 5xx），指数退避。上游仅对实现了 `onLoadFailed` JS 钩子的源有重试，弱网下其他源容易一碰就失败。
- **图片加载性能**：大图缓冲改用 `BytesBuilder`，减少反复扩容与复制的开销（缩略图与内页均覆盖）。
- **断点续传校验**：分块下载校验 `206 Partial Content`，服务端返回整文件时不再把内容写坏到错误偏移。
- **更友好的错误提示**：网络错误由 Dio 多行堆栈改为一行简洁的人话描述，保留 Cloudflare 验证与日志导出。

### 🛠 稳定性修复（节选）

- 阅读器在图片加载完成前点击、双击或收藏的空指针崩溃
- 快速切章 / 退出阅读器时的多处 `setState after dispose` 崩溃
- 抓取章节目录途中暂停导致的静默数据损坏（缺章）
- 取消下载后的协程死锁、文件句柄与定时器泄漏
- 图片收藏传错 id、取消收藏后缓存永不清理

### 📚 书源扩展（1.6.4 起）

默认源列表切换为本项目维护的扩展列表（**37 个源**）：上游
[venera-app/venera-configs](https://github.com/venera-app/venera-configs) 全部 33 个源
（拷贝漫画、MangaDex、comick、カドコミ、少年ジャンプ＋ 等，经 jsdelivr 直链**自动跟进上游更新**），
外加 4 个**逐文件安全审计**的免费源：

- **动漫屋** / **Mangabz** / **极速漫画** / **野蛮漫画** —— 免费中文漫画站

每个新增源都经过语法校验、域名白名单核对与可疑模式扫描，审计记录见
[hea784/venera-configs](https://github.com/hea784/venera-configs)。想只用上游原始列表，
在「漫画源 → 仓库 URL」改回 `https://cdn.jsdelivr.net/gh/venera-app/venera-configs@main/index.json` 即可。

### 🌏 全量汉化

- 界面文案**简体 / 繁体全量覆盖（零缺失）**，补齐上游遗留的未翻译字符串
- 非中文系统下也显示中文（上游会退化成英文原文）；台湾 / 香港 / 澳门设备正确显示繁体

### 🔗 仓库指向与构建

- 关于页、更新检查、帮助文档链接均指向本 fork，应用内可直接检查 fork 更新
- **1.6.4 起版本号回归标准语义**（不再用 fork 后缀）；同时修复了更新检查按钮对 `1.6.3-fork.x` 类版本号必然崩溃的问题
- 独立构建流水线：打 `v*` tag 即自动构建**已签名** release APK 并发布
- APK 同时启用 **v1 / v2 / v3 签名方案**，兼容 Android 6+ 及签名校验较严格的国产 ROM
- 独立版本号 `1.6.3-fork.x`，与官方 `1.6.3` 区分；各 fork 版本间签名一致，可直接覆盖升级

## 📥 下载安装

前往 [**Releases**](https://github.com/hea784/venera_0/releases/latest) 下载对应架构的 APK（不确定就选 `universal`），安装即用。

也可以在 [Actions](https://github.com/hea784/venera_0/actions/workflows/build-android.yml) 手动运行 **Build Android APK** 工作流获取最新构建产物。

### ⚠️ 从官方版迁移到本 fork（重要）

本 fork 使用**自己的签名密钥**，与官方 venera / F-Droid 版不同。Android 禁止不同签名覆盖安装，因此**从官方版升级必须先卸载旧版**：

1. （可选但推荐）先在旧版 **设置 → Data Sync** 备份数据，或记下已配置的漫画源
2. 卸载旧版 venera
3. 安装本 fork 的 APK

> 本 fork 历代版本（`v1.6.3-fork.1` ~ `fork.5`、`v1.6.4+`）签名一致，**直接覆盖升级即可**。

## 🧩 已有功能（继承自上游）

- 阅读本地漫画 / 网络漫画
- 用 JavaScript 编写漫画源（[venera-configs](https://github.com/venera-app/venera-configs) 生态，见[文档](doc/comic_source.md)）
- 收藏管理、漫画下载、断点续传
- 评论、标签等（取决于漫画源支持）
- WebDAV 数据同步、应用数据导出 / 导入
- [Headless 模式](doc/headless_doc.md)（桌面端辅助）

## 🏗 从源码构建

```bash
git clone https://github.com/hea784/venera_0.git
cd venera_0
flutter pub get
flutter build apk --release   # 需要 JDK 17、Android SDK 与 Rust
```

- Flutter **3.41.4**（stable）与其余依赖版本见 `pubspec.yaml`；桌面端构建同理（`windows` / `linux` / `macos`）
- 漫画源开发：[doc/comic_source.md](doc/comic_source.md) · JS API：[doc/js_api.md](doc/js_api.md)

## 🙏 致谢

- [venera-app/venera](https://github.com/venera-app/venera) 与作者 [wgh136](https://github.com/wgh136) 的 [PicaComic](https://github.com/wgh136/PicaComic) —— 本项目的上游与前身
- [EhTagTranslation](https://github.com/EhTagTranslation/Database) —— 漫画标签中文翻译
- [Mihon](https://github.com/mihonapp/mihon) / [Kotatsu](https://github.com/KotatsuApp/Kotatsu) —— 新功能的灵感来源

## 📄 License

[GPL-3.0](LICENSE) © 上游作者及本 fork 贡献者
