# DodoAI Task Instruction Template

**Universal template for any microservice in DodoAI monorepo**

## Quick Start

### 1. Copy starter template to Cline
```bash
cat .dodo/.cline-instruction-template/BASE_TEMPLATE/starter-template.md
```

### 2. Answer 3 questions
- Language: 日本語 or English
- Goal: What you want to achieve
- Issue: Ticket number (e.g., #598)
- Service: Which microservice (e.g., task-ms, ai-agent-ms)

### 3. Review & approve
- AI investigates code autonomously
- Reviews specifications and complexity
- Presents summary for your approval
- Generates complete task instruction file

## Output

Generated file location:
```
.dodo/.cline-instruction-template/hitoshi.murakami/{ServiceName}/{issue-number}-{task-name}.md
```

## Examples

- `TaskMS/598-two-task-chaining-workflow.md`
- `TaskMS/558-WF-Logs2.md`
