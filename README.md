# LangChain Agents

一个基于 LangChain 和 LangGraph 的智能天气助手项目，展示如何构建和部署 AI Agent 应用。

## 🌟 功能特性

- 🤖 **智能天气助手** - 基于自然语言查询天气信息
- 🛠️ **LangChain Agent** - 使用现代 Agent 架构构建
- 🐳 **容器化部署** - 支持 Docker 和 Docker Compose
- 🔄 **流式响应** - 实时响应用户查询
- 📊 **LangSmith 集成** - 完整的可观测性和监控
- 🌐 **REST API** - 标准化的 HTTP 接口
- 📦 **生产就绪** - 包含完整的部署配置

## 🚀 快速开始

### 前置要求

- Python 3.11+
- Docker & Docker Compose（用于容器化部署）
- 有效的 API 密钥

### 环境配置

1. **复制环境变量模板**
```bash
cp .env.example .env
```

2. **配置 API 密钥**
编辑 `.env` 文件：
```env
# OpenAI API 配置
OPENAI_API_KEY=your_openai_api_key_here
OPENAI_BASE_URL=https://api.openai.com/v1/

# 可选：使用自定义 API 端点
# OPENAI_API_KEY=your_custom_api_key
# OPENAI_BASE_URL=https://your-custom-endpoint.com/v1/

# LangSmith 配置（用于监控）
LANGSMITH_API_KEY=lsv2_pt_your_langsmith_api_key_here
```

3. **安装依赖**
```bash
pip install -r requirements.txt
# 或使用 uv（推荐）
uv pip install -r requirements.txt
```

## 🏃‍♂️ 运行项目

### 方式一：本地开发模式

最简单的开发和测试方式：

```bash
# 启动开发服务器
langgraph dev

# 或指定端口
langgraph dev --port 2024
```

**服务地址：**
- API: http://localhost:2024
- 文档: http://localhost:2024/docs
- 健康检查: http://localhost:2024/ok

### 方式二：Docker 容器化部署

推荐用于生产环境：

```bash
# 1. 构建镜像
langgraph build -t langchain-agents:latest

# 2. 启动服务
docker-compose up -d

# 或使用公开镜像（无需构建）
docker-compose -f docker-compose-public.yml up -d
```

**验证部署：**
```bash
# 检查服务状态
docker-compose ps

# 查看日志
docker-compose logs langgraph-api

# 健康检查
curl http://localhost:2024/ok
```

**停止服务：**
```bash
docker-compose down  # 停止并删除容器
```

## 🧪 API 使用

### 快速测试

```bash
# 健康检查
curl http://localhost:2024/ok

# 创建助手
curl -X POST http://localhost:2024/assistants \
  -H "Content-Type: application/json" \
  -d '{"graph_id": "agent", "config": {"configurable": {}}}'

# 创建对话线程
curl -X POST http://localhost:2024/threads \
  -H "Content-Type: application/json" \
  -d '{}'

# 发送消息（替换 {thread_id} 和 {assistant_id}）
curl -X POST http://localhost:2024/threads/{thread_id}/runs/stream \
  -H "Content-Type: application/json" \
  -d '{"assistant_id": "{assistant_id}", "input": {"messages": [{"role": "user", "content": "北京天气怎么样？"}]}}'
```

**完整 API 文档**: http://localhost:2024/docs

## 🏗️ 项目结构

```
langchain-agents/
├── src/
│   └── agents/
│       └── agent.py          # 主要 Agent 实现
├── .env.example              # 环境变量模板
├── .gitignore                # Git 忽略文件
├── docker-compose.yml        # 开发环境配置
├── docker-compose-public.yml # 生产环境配置
├── langgraph.json            # LangGraph 配置
├── pyproject.toml           # Python 项目配置
├── requirements.txt         # 依赖列表
└── release.sh              # 发布脚本
```

## 🔧 开发指南

### 修改 Agent

1. 编辑 `src/agents/agent.py`
2. 重新构建并重启：

```bash
# 本地开发模式：重启 langgraph dev 即可

# Docker 模式：
langgraph build -t langchain-agents:latest
docker-compose up -d --force-recreate
```

### 添加新工具

在 `agent.py` 中定义新的工具函数：

```python
@tool
def your_new_tool(param: str) -> str:
    """工具描述"""
    # 实现你的逻辑
    return "结果"
```

然后将工具添加到 agent 中。

## 🐛 故障排除

### 常见问题

| 问题 | 解决方案 |
|------|----------|
| **端口冲突** | `lsof -i :2024` 查看占用，`kill -9 <PID>` 杀死进程 |
| **API 密钥错误** | 检查 `.env` 文件中的密钥是否正确 |
| **容器启动失败** | `docker-compose logs langgraph-api` 查看日志 |
| **代码更新不生效** | 重新构建镜像：`langgraph build -t langchain-agents:latest` |

### 调试技巧

```bash
# 查看详细日志
docker-compose logs -f langgraph-api

# 进入容器调试
docker-compose exec langgraph-api bash

# 检查环境变量
docker-compose exec langgraph-api env | grep -E "(OPENAI|LANGSMITH)"
```

## 📊 监控

- **LangSmith Dashboard**: https://smith.langchain.com/
- **健康检查**: http://localhost:2024/ok
- **实时日志**: `docker-compose logs -f`

## 🚀 部署到生产

### 使用发布脚本

```bash
# 发布新版本
./release.sh v1.0.0
```

### 手动发布

```bash
# 1. 构建镜像
langgraph build -t langchain-agents:latest

# 2. 标记并推送
docker tag langchain-agents:latest bi4o1995/langchain-agents:latest
docker push bi4o1995/langchain-agents:latest

# 3. 更新 docker-compose-public.yml 中的镜像版本
```

## 📝 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/amazing-feature`
3. 提交更改：`git commit -m 'Add amazing feature'`
4. 推送分支：`git push origin feature/amazing-feature`
5. 提交 Pull Request

## 📞 获取帮助

- 📖 [LangGraph 官方文档](https://langchain-ai.github.io/langgraph/)
- 🐛 [报告问题](https://github.com/BI4O/langchain-agents-py/issues)
- 💬 [讨论区](https://github.com/BI4O/langchain-agents-py/discussions)