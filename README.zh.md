# /dev — Claude Code 多 Agent 开发 SOP

[English](./README.md)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-兼容-blue)](https://claude.com/claude-code)
[![类型](https://img.shields.io/badge/类型-slash%20command-purple)](https://docs.anthropic.com/en/docs/claude-code/slash-commands)

一个专为 [Claude Code](https://claude.com/claude-code) 设计的自定义 Skill，让 Claude 化身 **Tech Lead**，协调多个 AI Worker Agent 跑完一套完整的软件开发工作流——从需求对齐到 PR 合并。

---

## 为什么用 /dev？

大多数 AI 编程工具只是一个聪明的自动补全。`/dev` 给你的是一套**工程流程**。

| 没有 /dev | 用了 /dev |
|---|---|
| Claude 在对话里直接写代码 | Claude 担任 Tech Lead，自己从不写代码 |
| 没有结构，容易失控 | 从 PRD 到合并的 6 阶段 SOP |
| 单线程，一次只做一件事 | 多个 Worker Agent **并行**开发，各自在独立 worktree |
| 合并时才发现冲突 | 开发前自动扫描文件重叠，提前规避 |
| 安全审查靠人工 | `bandit` + `pip-audit` / `npm audit` 在每次 Review 前强制执行 |

---

## 工作流程

```
你：/dev 我想做一个 Todo 应用，支持用户注册和任务管理

Claude（Tech Lead）
  │
  ├─ Phase 0 ── 识别请求类型 → 新项目
  ├─ Phase 1 ── 对齐 PRD（两轮确认）
  ├─ Phase 2 ── 架构决策 + GitHub Issue 创建
  │
  ├─ Phase 3 ── 派生 Worker Agent（并行 worktree）
  │              ├─ Worker A：用户认证模块
  │              ├─ Worker B：任务 CRUD API
  │              └─ Worker C：前端组件
  │
  ├─ Phase 3.5 ── QA Agent 静态验证
  ├─ Phase 4 ── Code Review + 合并（7 项 Checklist）
  └─ Phase 5 ── Retro + 下一轮迭代
```

---

## 功能说明

`/dev` 是一套**多 Agent 软件开发标准流程**，覆盖：

- **Phase 0** — 请求类型识别与路由（新项目 / 新功能 / Bug 修复 / 紧急 Hotfix / 架构调整 / 重构）
- **Phase 1** — 产品对齐（直接使用现有 PRD，或两轮生成）
- **Phase 2** — 架构决策 + 任务拆解 + GitHub Issue 创建
- **Phase 3** — 多个 Worker Agent **并行**开发（每个 Agent 在独立 worktree 中工作）
- **Phase 3.5** — QA Agent 静态验证
- **Phase 4** — Code Review + 合并（7 项结构化 Checklist + 强制否决条件）
- **Phase 5** — Retro + 下一轮迭代循环

### 核心特性

- **Tech Lead 铁律**：主对话永远不直接写代码，所有变更必须通过 Worker Agent → PR → Review
- **6 类反例自查**：Worker Agent 提交前必须覆盖 Null / 空值 / 边界 / 外部调用失败 / 并发 / 恶意输入
- **预开发冲突检查**：Worker Agent 开始前自动扫描其他 open Issue 的文件重叠
- **合并后 PR 协调**：每次 PR 合并后扫描 open PR，通知需要 rebase 的分支
- **安全门控**：`bandit` + `pip-audit` / `npm audit` 在 Review 前强制运行
- **数据库迁移保护**：直接 DDL 操作（ALTER TABLE / DROP COLUMN）触发强制否决

---

## 前置要求

| 工具 | 说明 |
|------|------|
| [Claude Code](https://claude.com/claude-code) | Claude 官方 CLI，需要登录 |
| [GitHub CLI (`gh`)](https://cli.github.com/) | 用于创建 Issue、PR、Repo，先运行 `gh auth login` |
| Git | 版本控制 |

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
    phase1.md ~ phase5.md
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

Claude 会自动识别请求类型并进入对应流程。

---

## 项目结构

```
claude-dev-skill/
├── README.md               # 英文说明
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
        └── dev/ ...
```

---

## 适用场景

**适合：**
- 全新的中小型 Web 后端 / API 项目
- 有 PRD 文档、需要系统性开发的功能模块
- 多功能并行开发、希望规避 merge conflict 的场景

**不适合：**
- 需要生产部署的项目（暂无 DevOps/部署能力）
- 有大量存量数据的复杂数据库迁移
- 高合规安全要求的应用（金融、医疗）

---

## 参与贡献

欢迎提 Issue 和 PR。如果你有新阶段、新 Agent 角色或其他语言支持的想法，请先开 Issue 讨论。

---

## License

MIT — 见 [LICENSE](./LICENSE)
