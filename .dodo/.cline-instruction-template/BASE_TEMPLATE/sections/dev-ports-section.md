# Development Environment Port Configuration

**CRITICAL:** Always refer to the official port documentation before making assumptions.

## Quick Reference

| Service | Port | Environment | Documentation |
|---------|------|-------------|---------------|
| **AI Router MS** | **57771** | Local/ITB/Prod | `docusaurus/docs/1.DevOps/dev_environment/ai-router-ms/env-configuration.md` |
| **Task MS** | 8082 | Local | `docusaurus/docs/9.Task-ms/3.Run/local-development.md` |
| **Frontend** | 3000 | Local | `docusaurus/docs/3.frontend/2.Run/local-development.md` |
| **System API** | 3002 | Local | - |
| **VS Code Server** | 8080 | Docker | `.clinerules/06-startup-procedures.md` |
| **MCP WebSocket** | 9001 | Docker | `.clinerules/05-chat-pipeline-architecture.md` |

## AI Router MS Configuration

**⚠️ CRITICAL:** Port **57771** is HARDCODED in the frontend. Never use a different port.

### Environment Variables

```bash
# Server Configuration
SERVER_PORT=57771          # ✅ REQUIRED - Must be 57771
AI_ROUTER_PORT=57771       # Optional alias

# Local Development
AI_ROUTER_BASE_URL=http://localhost:57771

# ITB/Production
AI_ROUTER_BASE_URL=https://<domain>  # Port handled by gateway
```

### Local Startup

```bash
cd ai-router-ms
export PYTHONPATH=src
python3 -m uvicorn ai_router.infra.http.app:app \
  --host 127.0.0.1 \
  --port 57771 \
  --reload
```

### Docker Startup

```bash
cd ai-router-ms
docker compose up -d  # Uses SERVER_PORT=57771 from .env.itb
```

### Testing Configuration

All test files must use port **57771**:

```python
# Correct
AI_ROUTER_BASE_URL = os.getenv('AI_ROUTER_BASE_URL', 'http://localhost:57771')

# Wrong
AI_ROUTER_BASE_URL = 'http://localhost:8092'  # ❌ NEVER use 8092
```

## Task MS Configuration

**Port:** 8082 (Local development)

### Environment Variables

```bash
# Local
TASK_MS_BASE_URL=http://localhost:8082

# ITB
TASK_MS_BASE_URL=https://itb.dodoai.biz/api/task-ms
```

## Frontend Configuration

**Port:** 3000 (Local development with Vite)

### Environment Variables

```bash
# Development
VITE_API_BASE_URL=http://localhost:8082  # Task MS
VITE_AI_ROUTER_BASE_URL=http://localhost:57771  # AI Router

# Production
VITE_API_BASE_URL=https://api.dodoai.biz
VITE_AI_ROUTER_BASE_URL=https://api.dodoai.biz/ai-router
```

## Common Mistakes to Avoid

### ❌ Wrong Port Numbers

```bash
# Wrong
AI_ROUTER_BASE_URL=http://localhost:8092  # Old/incorrect port
AI_ROUTER_BASE_URL=http://localhost:8080  # VS Code Server port
AI_ROUTER_BASE_URL=http://localhost:3000  # Frontend port
```

### ✅ Correct Port Numbers

```bash
# Correct
AI_ROUTER_BASE_URL=http://localhost:57771  # AI Router MS
TASK_MS_BASE_URL=http://localhost:8082     # Task MS
FRONTEND_URL=http://localhost:3000         # Frontend
```

## Pre-Development Checklist

Before starting any development work:

1. ✅ Read official port documentation:
   - `docusaurus/docs/1.DevOps/dev_environment/ai-router-ms/env-configuration.md`
   - `docusaurus/docs/1.DevOps/dev_environment/itb/ports.md`

2. ✅ Verify environment variables:
   ```bash
   # AI Router MS
   echo $SERVER_PORT  # Should be 57771
   
   # Frontend
   echo $VITE_AI_ROUTER_BASE_URL  # Should use port 57771
   ```

3. ✅ Check running services:
   ```bash
   lsof -i :57771  # AI Router MS
   lsof -i :8082   # Task MS
   lsof -i :3000   # Frontend
   ```

## Port Conflict Resolution

### AI Router MS (Port 57771)

```bash
# Check what's using port 57771
lsof -i :57771

# Kill the process
kill -9 <PID>

# Or use pkill
pkill -f "ai_router"
```

### Task MS (Port 8082)

```bash
# Check what's using port 8082
lsof -i :8082

# Kill the process
pkill -f "task-ms"
```

### Frontend (Port 3000)

```bash
# Check what's using port 3000
lsof -i :3000

# Kill the process
pkill -f "vite"
```

## Testing with Correct Ports

### Cucumber Tests

```bash
# Set correct environment variable
export AI_ROUTER_BASE_URL=http://localhost:57771

# Run tests
cd ai-router-ms
python3 -m behave features/actions/
```

### Frontend Tests

```bash
# Ensure correct API URLs in .env
cat new_dodoai_react_app/.env.dev_with_itb
# Should contain:
# VITE_AI_ROUTER_BASE_URL=http://localhost:57771

# Run tests
cd new_dodoai_react_app
npm test
```

## Documentation References

### Official Port Documentation
- **AI Router MS:** `docusaurus/docs/1.DevOps/dev_environment/ai-router-ms/env-configuration.md`
- **ITB Ports:** `docusaurus/docs/1.DevOps/dev_environment/itb/ports.md`
- **Task MS:** `docusaurus/docs/9.Task-ms/3.Run/local-development.md`
- **Frontend:** `docusaurus/docs/3.frontend/2.Run/local-development.md`

### Cline Rules
- **Startup Procedures:** `.clinerules/06-startup-procedures.md`
- **Chat Pipeline:** `.clinerules/05-chat-pipeline-architecture.md`

## Summary

| Service | Port | Key Point |
|---------|------|-----------|
| AI Router MS | **57771** | ⚠️ HARDCODED in frontend - never change |
| Task MS | 8082 | Local development only |
| Frontend | 3000 | Vite dev server |
| VS Code Server | 8080 | Docker only |
| MCP WebSocket | 9001 | Chat pipeline |

**Remember:** When in doubt, always check the official documentation in `docusaurus/docs/1.DevOps/dev_environment/`.
