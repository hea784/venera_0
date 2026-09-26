# Contributing to hea784/venera_0

本仓库是 [venera-app/venera](https://github.com/venera-app/venera) 的维护 fork。上游已停止维护，本仓库的目标是让 Android 端的体验更稳、更好用。**上游已归档，本 fork 的改动无需向上游提 PR。**

## 发版

维护者按此流程发版；贡献代码只需保证 CI 通过：

1. 修改 `pubspec.yaml` 的 `version`（`MAJOR.MINOR.PATCH+VERSIONCODE`）
2. 提交并推送 `master`，打同名 `v*` 标签
3. CI 自动构建已签名 APK，构建完成后在 Releases 页面创建 Release 并上传产物

## 代码约定

- `flutter analyze` 必须零问题；提交前跑 `flutter test`
- 用户可见字符串统一走 `.tl`（英文原文作 key），并同步补进 `assets/translation.json` 的 `zh_CN` / `zh_TW`
- 新增设置项后运行 `python3 scripts/check_settings_index.py`（CI 也会检查），把新设置补进 `lib/foundation/settings_index.dart`，否则设置搜索找不到它
- 纯逻辑改动请补单测（`test/`，用真实报错字符串做样本最有价值）

## 反馈闭环

- 使用交流、功能建议 → [Discussions](https://github.com/hea784/venera_0/discussions)
- Bug 与漫画源故障 → [Issue 模板](https://github.com/hea784/venera_0/issues/new/choose)
  - 源故障请优先用「📇 漫画源故障」模板，**务必附上** 设置 → 调试 → 导出日志 的日志文件

## 漫画源相关

- 默认源列表是上游 [venera-app/venera-configs](https://github.com/venera-app/venera-configs)，源的故障请勿在本仓库提 Issue
- 本项目另有一个可选的扩展列表 [hea784/venera-configs](https://github.com/hea784/venera-configs)（上游源 + 审计过的免费源）。新增源会先过 CI 审计（语法 / 域名白名单 / 危险模式），详见该仓库 README
- 源列表地址可在「漫画源 → 仓库 URL」自由切换，升级不会被覆盖
