---
name: skill-retrieval
description: "Skill retrieval and management system for discovering, loading, and using skills across projects. Hard scope, trigger rules, progressive disclosure, data contracts, write/read workflows."
category: "workflow"
tags: ["skill", "retrieval", "discovery", "management", "manifest", "progressive-disclosure", "skill-registry"]
provides:
  commands: ["skill-list", "skill-search", "skill-install", "skill-update", "skill-remove", "skill-info", "skill-enable", "skill-disable", "skill-sync", "skill-create", "skill-migrate"]
  hooks: ["session-start", "pre-task", "post-task"]
compatibleWith: ["opencode", "claude-code"]
license: MIT
metadata:
  version: "2.0.0"
---

## Overview

The skill retrieval system provides:
1. **Skill Discovery** - Find skills from multiple sources (local, remote, marketplace)
2. **Skill Loading** - Load skills dynamically based on project needs
3. **Skill Management** - Install, update, remove, and configure skills
4. **Skill Composition** - Combine skills for complex workflows
5. **Skill Sync** - Share skills between opencode and claude code

## Architecture

### Skill Sources

```
~/.config/opencode/skills/          # User global skills
~/.config/claude/skills/            # User global skills (claude)
./opencode/skills/                  # Project skills (opencode)
./claude/skills/                    # Project skills (claude)
~/.opencode/plugins/*/skills/       # Plugin-provided skills
~/.claude/plugins/*/skills/         # Plugin-provided skills (claude)
https://github.com/awesome-opencode/awesome-opencode  # Community skills
https://github.com/opencode-ai/skills                  # Official skills
```

### Skill Manifest (skill.yaml)

Each skill directory contains a `skill.yaml` manifest:

```yaml
name: skill-name
version: "1.0.0"
description: "Brief description of what this skill does"
author: "Author Name"
license: "MIT"
source: "local|github|npm|marketplace"
repository: "https://github.com/user/repo"  # if github
entryPoint: "skill.md"  # or .py, .js, .sh for executable skills
tags: ["tag1", "tag2", "category"]
dependencies: []  # other skills required
provides:
  commands: ["cmd1", "cmd2"]
  tools: ["tool1", "tool2"]
  hooks: ["pre-task", "post-edit"]
compatibleWith: ["opencode", "claude-code"]
minVersion: "1.0.0"
```

### Skill Categories

- **coding** - Code writing, refactoring, patterns
- **testing** - Test generation, execution, coverage
- **security** - Security auditing, vulnerability scanning
- **documentation** - Doc generation, changelog, API docs
- **workflow** - Git, CI/CD, project management
- **language** - Language-specific (rust, python, nix, etc.)
- **tooling** - LSP, formatter, linter integration
- **memory** - Context, memory, knowledge management
- **analysis** - Code analysis, metrics, complexity
- **design** - Architecture, UI/UX, patterns

## Retrieval API

### CLI Commands

```bash
# List available skills
/skill list [--category=CATEGORY] [--source=SOURCE] [--installed]

# Search skills
/skill search "query" [--tags=TAG1,TAG2]

# Install skill
/skill install SOURCE/NAME [--version=VERSION] [--global]

# Update skill
/skill update NAME [--version=VERSION]

# Remove skill
/skill remove NAME [--global]

# Show skill info
/skill info NAME

# Enable/disable skill for current project
/skill enable NAME
/skill disable NAME

# Sync skills between opencode and claude
/skill sync [--direction=opencode-to-claude|claude-to-opencode|both]

# Create new skill template
/skill create NAME --category=CATEGORY [--template=TEMPLATE]
```

### Skill Loader (Python)

```python
# ~/.config/opencode/skills/skill_loader.py
import yaml
import os
from pathlib import Path
from typing import Dict, List, Optional

class SkillRegistry:
    def __init__(self):
        self.sources = [
            Path.home() / ".config/opencode/skills",
            Path.home() / ".config/claude/skills",
            Path.cwd() / "opencode/skills",
            Path.cwd() / "claude/skills",
        ]
        self.plugins_dir = Path.home() / ".opencode/plugins"
        self.cache = {}
    
    def discover(self) -> Dict[str, dict]:
        """Discover all available skills from all sources"""
        skills = {}
        for source in self.sources:
            if source.exists():
                for skill_dir in source.iterdir():
                    if skill_dir.is_dir():
                        manifest = skill_dir / "skill.yaml"
                        if manifest.exists():
                            with open(manifest) as f:
                                data = yaml.safe_load(f)
                                data['path'] = str(skill_dir)
                                data['source'] = 'local'
                                skills[data['name']] = data
        return skills
    
    def load(self, name: str) -> Optional[dict]:
        """Load a specific skill by name"""
        skills = self.discover()
        if name in skills:
            skill = skills[name]
            entry = Path(skill['path']) / skill['entryPoint']
            if entry.exists():
                skill['content'] = entry.read_text()
            return skill
        return None
    
    def get_by_tag(self, tag: str) -> List[dict]:
        """Get all skills with a specific tag"""
        return [s for s in self.discover().values() if tag in s.get('tags', [])]
    
    def get_by_category(self, category: str) -> List[dict]:
        """Get all skills in a category"""
        return self.get_by_tag(category)
    
    def install_from_github(self, repo: str, version: str = "main") -> bool:
        """Install a skill from GitHub"""
        # Implementation would clone repo, verify manifest, copy to skills dir
        pass
    
    def sync_with_claude(self, direction: str = "both") -> bool:
        """Sync skills between opencode and claude code"""
        # Implementation would copy/link skills between config dirs
        pass

# Usage
registry = SkillRegistry()
skills = registry.discover()
python_skills = registry.get_by_category("python")
```

### Skill Auto-Loading

Skills can be auto-loaded based on:
1. **Project detection** - Detect project type (Rust, Python, Nix, etc.) and load relevant skills
2. **Task keywords** - Load skills when task mentions keywords
3. **File patterns** - Load skills when editing certain file types
4. **Explicit configuration** - User-defined skill sets per project

```yaml
# .opencode/skills.yaml (project skill config)
autoLoad:
  - category: "language"
    match:
      files: ["*.rs", "Cargo.toml"]
  - category: "testing"
    match:
      files: ["*_test.py", "test_*.py", "pytest.ini"]
  - category: "security"
    match:
      keywords: ["security", "audit", "vulnerability", "secret"]
  - category: "workflow"
    match:
      keywords: ["git", "commit", "pr", "branch", "merge"]

enabled:
  - "clean-code"
  - "nix-flake"
  - "changelog"
  - "git-workflow"
  - "testing"
  - "security-checkers"

disabled:
  - "legacy-skill"
```

## Integration with Opencode/Claude

### Opencode Configuration

```json
{
  "skills": {
    "autoLoad": true,
    "projectConfig": ".opencode/skills.yaml",
    "globalConfig": "~/.config/opencode/skills.yaml",
    "marketplace": "https://github.com/awesome-opencode/awesome-opencode",
    "syncWithClaude": true
  }
}
```

### Claude Code Configuration

```json
{
  "skills": {
    "autoLoad": true,
    "projectConfig": ".claude/skills.yaml",
    "globalConfig": "~/.config/claude/skills.yaml",
    "syncWithOpencode": true
  }
}
```

## Skill Templates

### Basic Skill Template

```markdown
---
name: my-skill
description: "Description of the skill"
category: "coding"
tags: ["coding", "refactoring"]
provides:
  commands: ["my-command"]
---

# My Skill

## When to Use
Use this skill when...

## Instructions
1. Step one
2. Step two

## Examples
```bash
# Example usage
```
```

### Executable Skill Template (Python)

```python
#!/usr/bin/env python3
"""
Skill: my-skill
Description: Executable skill that performs an action
"""

import sys
import json

def main():
    # Read input from stdin (JSON)
    input_data = json.load(sys.stdin)
    
    # Process
    result = process(input_data)
    
    # Output result as JSON
    json.dump(result, sys.stdout)

def process(data):
    # Skill logic here
    return {"status": "success", "data": data}

if __name__ == "__main__":
    main()
```

## Best Practices

1. **Keep skills focused** - One skill, one purpose
2. **Version skills** - Use semantic versioning
3. **Document dependencies** - List required skills/tools
4. **Test skills** - Include test cases in skill directory
5. **Share via marketplace** - Publish to awesome-opencode
6. **Sync between agents** - Use the sync command regularly
7. **Project-specific overrides** - Allow project config to override global

## Migration from Current Setup

Current skills in `home/ai/skills/`:
- clean-code.md
- humanizer.md

New skills to add:
- nix-flake
- changelog
- git-workflow
- testing
- security-checkers
- verification-planning
- simplify
- refactor-plan
- context-map
- composition-patterns
- refactor
- git-commit
- token-coach
- token-dashboard
- fleet-auditor
- ponytail
- ponytail-audit
- ponytail-debt
- ponytail-gain
- ponytail-help
- ponytail-review
- deepwork
- reflect
- worktrees
- customize-opencode
- clonedeps
- codemap

Run migration:
```bash
/skill migrate --from=home/ai/skills --to=~/.config/opencode/skills
```

## Hard Scope

This skill **only reads/writes inside its own `skill-manifests/` directory** (or equivalent configured location). It never touches other repository paths, project files, or system directories outside its designated scope.

## Trigger Rules

Two intents activate this skill:

| Intent | User Phrases | Action |
|--------|--------------|--------|
| **Write intent** | "list skills", "search skills", "install skill", "update skill", "remove skill", "configure skill", "create skill", "sync skills" | Modify skill registry, install/update/remove skills |
| **Recall intent** | "what does skill X do", "how to install skill", "show skill commands", "recall skill X", "find skill for [task]" | Read skill manifests, return info |

## Storage Layout

```
skill-manifests/
├── index.json              # Global index: entries[] + keywordMap
├── overview.md             # High-level summaries only
├── items/                  # Individual skill manifests (by category)
│   ├── coding/
│   │   ├── clean-code.yaml
│   │   └── ...
│   ├── testing/
│   │   └── ...
│   └── ...
└── templates/              # Skill creation templates
    ├── basic.yaml
    ├── executable.yaml
    └── ...
```

## Data Contract

### Manifest File (`skill.yaml`)

```yaml
name: skill-name              # Required: kebab-case, unique
version: "1.0.0"              # Required: semver
description: "What it does"   # Required: ≥20 chars
author: "Author Name"         # Optional
license: "MIT"                # Optional: SPDX identifier
source: "local|github|npm"    # Required
repository: "https://..."     # If github
entryPoint: "skill.md"        # Required: path to skill content
tags: ["tag1", "category"]    # Required: at least category tag
dependencies: []              # Optional: other skill names
provides:                     # Optional
  commands: ["cmd1"]
  tools: ["tool1"]
  hooks: ["pre-task"]
compatibleWith: ["opencode"]  # Required
minVersion: "1.0.0"           # Optional
```

### Global Index (`index.json`)

```json
{
  "entries": [
    {
      "name": "clean-code",
      "version": "2.0.0",
      "description": "Clean code review and refactor",
      "tags": ["coding", "refactoring"],
      "source": "local",
      "path": "items/coding/clean-code.yaml",
      "updatedAt": "2024-09-15T10:30:00Z"
    }
  ],
  "keywordMap": {
    "refactor": ["clean-code"],
    "clean": ["clean-code"],
    "lint": ["clean-code", "security-checkers"]
  }
}
```

### Overview File (`overview.md`)

```markdown
# Skill Registry Overview

## Coding
- **clean-code** (v2.0.0) — Clean code review/refactor with 6-step workflow
- **humanizer** (v2.9.1) — Remove AI writing patterns

## Testing
- **testing** (v2.0.0) — Comprehensive test strategies

... (high-level only, no full details)
```

## Progressive Disclosure Retrieval (Skill Search)

1. **Extract keywords** — Pull 1–5 keywords from user request
2. **Read index** — Load `index.json` and consult `keywordMap`
3. **Rank candidates** — Score by keyword match, recency, category relevance
4. **Open top 1–5** — Load only the matched manifest files for full details
5. **Return** — Matched keywords + skill names + summaries

## Write Workflow (Install/Create Skill)

1. **Distill purpose** — Title + one-line summary from user request
2. **Create skill dir** — `skill-manifests/items/<category>/<name>/` with `skill.yaml` (+ templates/executables)
3. **Update index** — Append entry, update `keywordMap`, set timestamp
4. **Update overview** — Add one-line entry to `overview.md`
5. **Confirm** — Report what was stored + recall keywords (name, tags)

## Read Workflow (Recall Skill Info)

1. **Extract keywords** — From user question ("how to install X", "what does Y do")
2. **Query index** — Match against `keywordMap` and entry descriptions
3. **Open manifests** — Load matched `skill.yaml` files
4. **Return** — Keywords, skill name, summary, requested details (commands, hooks, entryPoint)

## Description Growth Policy

- Keep **this skill's description** focused on its own capability (skill retrieval)
- Put **growing summaries of other skills** in `overview.md`
- Keep **full skill details** in individual manifest files (`items/*/*.yaml`)