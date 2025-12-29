# LangChain Agents 项目

这是一个基于 LangChain 和 LangGraph 的智能天气助手项目，支持通过 Docker 容器化部署或本地开发模式运行。

## 🚀 功能特性

- 🤖 智能天气查询助手
- 🛠️ 基于 LangChain Agent 架构
- 🐳 Docker 容器化部署
- 🔄 支持流式响应
- 📊 LangSmith 集成监控
- 🌐 REST API 接口
- 📦 Docker Hub 公开镜像支持

## 📋 前置要求

### 通用要求
- Python 3.11+
- OpenAI API Key
- LangSmith API Key

### Docker 部署要求
- Docker Desktop
- Docker Compose

## 🛠️ 安装与配置

### 1. 环境配置

复制并编辑环境变量文件：

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入你的 API 密钥：

```env
# OpenAI 配置
OPENAI_API_KEY=your_openai_api_key_here
OPENAI_BASE_URL=https://api.openai.com/v1/

# 或者使用自定义 API 端点
# OPENAI_API_KEY=sk-a74642da91edf55b067cfde3e9c8917e
# OPENAI_BASE_URL=https://apis.iflow.cn/v1/

# LangSmith 配置（必需）
LANGSMITH_API_KEY=lsv2_pt_your_langsmith_api_key_here
```

### 2. 依赖安装

```bash
# 安装项目依赖
pip install -r requirements.txt

# 或者使用 uv（推荐）
uv pip install -r requirements.txt
```

## 🏃‍♂️ 运行方式

### 方式一：本地开发模式 (`langgraph dev`)

#### 启动服务

```bash
# 启动开发服务器
langgraph dev

# 或者指定端口
langgraph dev --port 2024
```

启动后你会看到类似输出：
```
Starting local dev server...
Server running on http://localhost:2024
API docs available at http://localhost:2024/docs
```

#### 访问服务
- **API 端点**: http://localhost:2024
- **API 文档**: http://localhost:2024/docs
- **健康检查**: http://localhost:2024/ok

#### 停止服务
在终端中按 `Ctrl + C` 停止开发服务器。

---

### 方式二：Docker 容器化部署

#### 构建镜像

```bash
# 构建 LangGraph Docker 镜像
langgraph build -t langchain-agents:latest
```

构建过程输出：
```
Building...
#0 building with "desktop-linux" instance using docker driver
...
#15 naming to docker.io/library/langchain-agents:latest done
#15 DONE 0.1s
```

#### 启动服务

**选择配置文件：**

```bash
# 开发环境（需要先构建镜像）
langgraph build -t langchain-agents:latest
docker-compose up -d

# 生产/分享环境（使用公开镜像，无需构建）
docker-compose -f docker-compose-public.yml up -d
```

**两个配置文件的区别：**
- `docker-compose.yml` - 使用本地镜像，适合开发
- `docker-compose-public.yml` - 使用 Docker Hub 镜像，适合分享和生产

推荐使用 `-d` 参数后台运行，关掉终端服务也不会停止。

启动后会看到：
```
Container langchain-agents-langgraph-postgres-1  Running
Container langchain-agents-langgraph-redis-1     Running
Container langchain-agents-langgraph-api-1      Started
```

#### 验证服务状态

```bash
# 检查所有容器状态
docker-compose ps

# 查看日志
docker-compose logs langgraph-api

# 健康检查
curl http://localhost:2024/ok
```

#### 访问服务
- **API 端点**: http://localhost:2024
- **API 文档**: http://localhost:2024/docs
- **健康检查**: http://localhost:2024/ok

#### 停止服务

```bash
# 停止所有服务并删除容器
docker-compose down

# 停止并删除数据卷（会清空数据）
docker-compose down -v

# 仅停止服务但保留容器
docker-compose stop

# 查看后台运行的服务状态
docker-compose ps

# 查看实时日志
docker-compose logs -f
```

## 🧪 API 使用示例

**健康检查**
```bash
curl http://localhost:2024/ok
```

**快速测试**
```bash
# 1. 创建助手
curl -X POST http://localhost:2024/assistants \
  -H "Content-Type: application/json" \
  -d '{"graph_id": "agent", "config": {"configurable": {}}}'

# 2. 创建对话
curl -X POST http://localhost:2024/threads \
  -H "Content-Type: application/json" \
  -d '{}'

# 3. 运行助手（替换实际的ID）
curl -X POST http://localhost:2024/threads/{thread_id}/runs/stream \
  -H "Content-Type: application/json" \
  -d '{"assistant_id": "{assistant_id}", "input": {"messages": [{"role": "user", "content": "北京天气怎么样？"}]}}'
```

**API 文档**: http://localhost:2024/docs

## 🔧 开发指南

### 项目结构
```
langchain-agents/
├── src/agents/agent.py      # 主要 Agent 代码
├── .env                     # 环境变量
├── docker-compose.yml       # 开发环境配置
├── docker-compose-public.yml # 生产环境配置
└── release.sh               # 发布脚本
```

### 修改 Agent
编辑 `src/agents/agent.py`，然后重新构建：
```bash
langgraph build -t langchain-agents:latest
docker-compose up -d --force-recreate
```

## 🐛 故障排除

### 常见问题

**LangSmith API 错误**
- 确保 `.env` 文件中的 `LANGSMITH_API_KEY` 有效

**端口冲突**
```bash
lsof -i :2024  # 查看占用
kill -9 <PID>  # 杀死进程
```

**容器启动失败**
```bash
docker-compose logs langgraph-api  # 查看日志
docker-compose up -d --force-recreate  # 重启
```

**代码更新后不生效**
```bash
langgraph build -t langchain-agents:latest  # 重新构建
docker-compose up -d --force-recreate  # 重启容器
```

## 📊 监控与日志

**LangSmith 监控**
- 访问 [LangSmith Dashboard](https://smith.langchain.com/) 查看运行记录

**日志查看**
```bash
# Docker 日志
docker-compose logs -f langgraph-api
```

## 🔄 更新与维护

### 更新代码

修改代码后重新部署：

```bash
# 开发环境更新
langgraph build -t langchain-agents:latest
docker-compose up -d --force-recreate
```

### 备份数据

```bash
# 备份数据
docker-compose exec langgraph-postgres pg_dump -U postgres postgres > backup.sql
# 恢复数据
docker-compose exec -T langgraph-postgres psql -U postgres postgres < backup.sql
```

## 📦 推送到 Docker Hub

### 推送镜像

```bash
# 1. 登录 Docker Hub
docker login

# 2. 重新标记并推送
docker tag langchain-agents:latest bi4o1995/langchain-agents:latest
docker push bi4o1995/langchain-agents:latest
```

### 使用公开镜像

其他人可以直接使用：
```bash
# 使用公开镜像（无需构建）
docker-compose -f docker-compose-public.yml up -d
```

### 版本管理

更新代码后发布新版本：

#### 方法一：快速推送
```bash
langgraph build -t langchain-agents:latest
docker tag langchain-agents:latest bi4o1995/langchain-agents:latest
docker push bi4o1995/langchain-agents:latest
```

#### 方法二：版本号推送（推荐）
```bash
# 使用发布脚本（最简单）
./release.sh v1.0.1

# 或手动发布
VERSION="v1.0.1"
langgraph build -t langchain-agents:latest
docker tag langchain-agents:latest bi4o1995/langchain-agents:latest
docker tag langchain-agents:latest bi4o1995/langchain-agents:${VERSION}
docker push bi4o1995/langchain-agents:latest
docker push bi4o1995/langchain-agents:${VERSION}
```

**版本格式：** `v1.0.0` (主版本.次版本.修订版本)

## 📝 许可证

本项目采用 MIT 许可证。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📞 支持

如果遇到问题，请：
1. 查看本文档的故障排除部分
2. 检查 [LangGraph 官方文档](https://langchain-ai.github.io/langgraph/)
3. 在项目仓库提交 Issue