#!/bin/bash

# LangChain Agents 发布脚本
# 使用方法: ./release.sh v1.0.1

set -e

# 配置
DOCKER_USERNAME="bi4o1995"
IMAGE_NAME="langchain-agents"

# 检查参数
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <version>"
    echo "例如: $0 v1.0.1"
    exit 1
fi

VERSION=$1

# 检查版本格式
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "错误: 版本号格式不正确，应为 v1.0.0 格式"
    exit 1
fi

echo "🚀 开始发布 LangChain Agents $VERSION"

# 1. 构建镜像
echo "📦 构建镜像..."
langgraph build -t ${IMAGE_NAME}:latest

# 2. 创建标签
echo "🏷️  创建标签..."
docker tag ${IMAGE_NAME}:latest ${DOCKER_USERNAME}/${IMAGE_NAME}:latest
docker tag ${IMAGE_NAME}:latest ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}

# 3. 推送镜像
echo "📤 推送镜像到 Docker Hub..."
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:latest
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}

# 4. 验证
echo "✅ 验证推送..."
docker pull ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}

# 5. 显示本地镜像
echo ""
echo "📋 本地镜像列表:"
docker images | grep ${DOCKER_USERNAME}/${IMAGE_NAME}

echo ""
echo "🎉 发布完成!"
echo "🌐 Docker Hub: https://hub.docker.com/r/${DOCKER_USERNAME}/${IMAGE_NAME}"
echo "📦 镜像地址: ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
echo "📦 镜像地址: ${DOCKER_USERNAME}/${IMAGE_NAME}:latest"