# PROJECT_CONTEXT.md 模板

> 将此文件内容复制到项目根目录的 `PROJECT_CONTEXT.md`，并填入实际内容。
> `/dev` skill 在每个 Phase 都会读取此文件恢复上下文。

---

```markdown
# PROJECT_CONTEXT

## 仓库信息
- **仓库地址**：https://github.com/[owner]/[repo]
- **主分支**：main
- **创建时间**：YYYY-MM-DD

## 技术栈
- **语言**：Python 3.11 / Node.js 20 / ...
- **框架**：FastAPI / Express / ...
- **数据库**：PostgreSQL / SQLite / ...
- **测试框架**：pytest / Jest / 无

## 架构决策
- **认证方案**：JWT，存储于 HttpOnly Cookie / localStorage
- **API 规范**：RESTful，错误格式 `{"error_code": "...", "message": "..."}`，分页用 `?page=&size=`
- **数据库迁移框架**：Alembic（有存量数据）/ 无（全新项目）
- **API Contract 文档**：`API_CONTRACT.md`（前后端分离时存在）

## 代码风格约定
- **命名规范**：Python snake_case，类名 PascalCase
- **目录结构**：
  ```
  src/
    routers/    # API 路由层
    services/   # 业务逻辑层
    models/     # 数据模型
    utils/      # 工具函数
  tests/
  ```
- **错误处理约定**：统一抛出 HTTPException，不在路由层写业务逻辑

## 已完成功能
- [ ] 示例：用户注册/登录（PR #3，2024-01-15 合并）
- [ ] 示例：商品列表 API（PR #5，2024-01-20 合并）

## 当前状态
- **最后更新**：YYYY-MM-DD
- **当前迭代目标**：[本轮要完成的功能描述]
- **已知技术债**：[如有]
- **开放 PR**：#N [描述]，#M [描述]
```
