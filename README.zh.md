# /dev — Claude Code 多 Agent 软件开发 SOP

[English](./README.md)

一个面向 [Claude Code](https://claude.com/claude-code) 的自定义 Skill，让 Claude 扮演 **Tech Lead**，带领多个 AI Worker Agent 完成软件项目的完整开发流程——从需求对齐到 PR 合并。

---

## 这是什么

`/dev` 是一套**多 Agent 软件开发标准流程**，覆盖：

- **Phase 0** — 需求性质识别与路由（新项目 / 新功能 / Bug 修复 / 紧急 Hotfix / 架构变更 / 重构）
- **Phase 1** — 产品需求对齐（直接使用你的 PRD，或两轮问答生成）
- **Phase 2** — 架构决策 + 任务拆解 + GitHub Issue 创建
- **Phase 3** — 多 Worker Agent **并行**开发（每个 Agent 在独立 worktree 工作）
- **Phase 3.5** — QA Agent 静态验证
- **Phase 4** — Code Review + 合并（7 项结构化 Checklist + 强制否决条件）
- **Phase 5** — Retro + 下一轮循环

### 核心特性

- **Tech Lead 铁律**：主对话永远不直接写代码，所有变更通过 Worker Agent → PR → Review
- **6 类反例驱动自检**：Worker Agent 编码后必须覆盖 Null / 空值 / 边界 / 外部依赖失败 / 并发 / 恶意输入
- **并行冲突检查**：Worker Agent 开工前自动扫描其他 open Issue 的文件重叠
- **合并后 PR 协调**：每次 PR 合并后扫描 open PR，通知需要 rebase 的分支
- **安全门控**：`bandit` + `pip-audit` / `npm audit` 在 Review 前强制运行
- **数据库迁移保护**：直接 DDL 操作（ALTER TABLE / DROP COLUMN）触发强制否决

---

## 前置要求

| 工具 | 说明 |
|------|------|
| [Claude Code](https://claude.com/claude-code) | Claude 官方 CLI，需登录 |
| [GitHub CLI (`gh`)](https://cli.github.com/) | 用于创建 Issue、PR、Repo，需 `gh auth login` |
| Git | 版本管理 |

---

## 安装

**方式 1：脚本安装（推荐）**

```bash
# macOS / Linux — 安装中文版
bash install.sh --lang zh

# macOS / Linux — 安装英文版
bash install.sh --lang en

# Windows PowerShell — 中文版
.\install.ps1 -Lang zh

# Windows PowerShell — 英文版
.\install.ps1 -Lang en
```

**方式 2：手动安装**

将 `zh/commands/`（或 `en/commands/`）下的所有文件复制到 `~/.claude/commands/`，保持目录结构：

```
~/.claude/commands/
  dev.md
  dev/
    phase1.md ~ phase4.md
    worker-new.md
    worker-fix.md
    qa-agent.md
    PROJECT_CONTEXT_TEMPLATE.md
```

---

## 使用方法

在 Claude Code 中输入：

```
/dev [可选的初始描述]
```

示例：
```
/dev 我想做一个 Todo 应用，支持用户注册和任务管理
/dev
```

Claude 会自动识别需求类型并进入对应流程。

---

## 项目结构

```
claude-dev-skill/
├── README.md               # 英文版说明
├── README.zh.md            # 本文件（中文）
├── LICENSE
├── install.sh              # macOS/Linux 安装脚本
├── install.ps1             # Windows 安装脚本
├── en/                     # 英文版 skill 文件
│   └── commands/
│       ├── dev.md
│       └── dev/ ...
└── zh/                     # 中文版 skill 文件
    └── commands/
        ├── dev.md
        └── dev/ ...
```

---

## 适合的场景

- 全新的中小型 Web 后端 / API 项目
- 有 PRD 文档、需要系统化开发的功能模块
- 需要多功能并行开发，想避免 merge conflict

## 不适合的场景

- 需要上线的生产环境（无 DevOps/部署能力）
- 有存量数据的复杂数据库迁移
- 高安全合规要求的应用（金融、医疗）

---

## License

MIT — 详见 [LICENSE](./LICENSE)
