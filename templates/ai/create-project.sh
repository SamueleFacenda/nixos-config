#!/usr/bin/env bash
# {{project_name}} - AI-assisted development project
# {{project_description}}
#
# This script creates a new project from the AI template.
# Usage: ./create-project.sh <project-name> <description> <author> <email> <github-user>

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check arguments
if [ $# -lt 5 ]; then
    echo -e "${RED}Usage: $0 <project-name> <description> <author-name> <author-email> <github-user>${NC}"
    echo "Example: $0 my-ai-project \"AI-powered code review\" \"John Doe\" \"john@example.com\" \"johndoe\""
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_DESCRIPTION="$2"
AUTHOR_NAME="$3"
AUTHOR_EMAIL="$4"
GITHUB_USER="$5"
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${PWD}/${PROJECT_NAME}"

echo -e "${BLUE}🚀 Creating AI-assisted development project: ${PROJECT_NAME}${NC}"
echo -e "${BLUE}   Description: ${PROJECT_DESCRIPTION}${NC}"
echo -e "${BLUE}   Author: ${AUTHOR_NAME} <${AUTHOR_EMAIL}>${NC}"
echo -e "${BLUE}   GitHub: ${GITHUB_USER}${NC}"
echo

# Check if target directory exists
if [ -d "${TARGET_DIR}" ]; then
    echo -e "${RED}Error: Directory ${TARGET_DIR} already exists${NC}"
    exit 1
fi

# Create target directory
mkdir -p "${TARGET_DIR}"
cd "${TARGET_DIR}"

# Copy template files
echo -e "${YELLOW}📁 Copying template files...${NC}"
cp -r "${TEMPLATE_DIR}"/* .
cp -r "${TEMPLATE_DIR}"/.github . 2>/dev/null || true
cp -r "${TEMPLATE_DIR}"/.gitlab* . 2>/dev/null || true
cp "${TEMPLATE_DIR}"/.envrc . 2>/dev/null || true
cp "${TEMPLATE_DIR}"/.pre-commit-config.yaml . 2>/dev/null || true
cp "${TEMPLATE_DIR}"/.cliff.toml . 2>/dev/null || true

# Replace placeholders
echo -e "${YELLOW}🔧 Replacing placeholders...${NC}"
find . -type f \( -name "*.toml" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.md" -o -name "*.rs" -o -name "*.py" -o -name "*.ts" -o -name "*.sh" -o -name "*.txt" \) \
    -not -path "./.git/*" \
    -not -path "./target/*" \
    -not -path "./dist/*" \
    -not -path "./.direnv/*" \
    -not -path "./.cache/*" \
    -exec sed -i "s/{{project_name}}/${PROJECT_NAME}/g" {} \;
find . -type f \( -name "*.toml" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.md" -o -name "*.rs" -o -name "*.py" -o -name "*.ts" -o -name "*.sh" -o -name "*.txt" \) \
    -not -path "./.git/*" \
    -not -path "./target/*" \
    -not -path "./dist/*" \
    -not -path "./.direnv/*" \
    -not -path "./.cache/*" \
    -exec sed -i "s/{{project_description}}/${PROJECT_DESCRIPTION}/g" {} \;
find . -type f \( -name "*.toml" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.md" -o -name "*.rs" -o -name "*.py" -o -name "*.ts" -o -name "*.sh" -o -name "*.txt" \) \
    -not -path "./.git/*" \
    -not -path "./target/*" \
    -not -path "./dist/*" \
    -not -path "./.direnv/*" \
    -not -path "./.cache/*" \
    -exec sed -i "s/{{author_name}}/${AUTHOR_NAME}/g" {} \;
find . -type f \( -name "*.toml" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.md" -o -name "*.rs" -o -name "*.py" -o -name "*.ts" -o -name "*.sh" -o -name "*.txt" \) \
    -not -path "./.git/*" \
    -not -path "./target/*" \
    -not -path "./dist/*" \
    -not -path "./.direnv/*" \
    -not -path "./.cache/*" \
    -exec sed -i "s/{{author_email}}/${AUTHOR_EMAIL}/g" {} \;
find . -type f \( -name "*.toml" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.md" -o -name "*.rs" -o -name "*.py" -o -name "*.ts" -o -name "*.sh" -o -name "*.txt" \) \
    -not -path "./.git/*" \
    -not -path "./target/*" \
    -not -path "./dist/*" \
    -not -path "./.direnv/*" \
    -not -path "./.cache/*" \
    -exec sed -i "s/{{github_user}}/${GITHUB_USER}/g" {} \;

# Initialize git
echo -e "${YELLOW}📦 Initializing git repository...${NC}"
git init
git add .
git commit -m "chore: initial commit from AI template"

# Create initial changelog
echo -e "${YELLOW}📝 Creating initial changelog...${NC}"
cat > CHANGELOG.md <<EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project structure from AI template
- Multi-language support (Rust, Python, Node.js)
- OpenRouter integration with token optimization
- Pre-commit hooks with git-hooks.nix
- GitHub Actions and GitLab CI/CD pipelines
- Docker support
- Comprehensive test setup

EOF

git add CHANGELOG.md
git commit -m "docs: add initial changelog"

# Initialize direnv
echo -e "${YELLOW}🔧 Setting up direnv...${NC}"
direnv allow . 2>/dev/null || true

# Create .envrc.local template
cat > .envrc.local.example <<EOF
# Local environment overrides
# Copy this file to .envrc.local and fill in your values
# DO NOT commit .envrc.local to version control!

# OpenRouter API Key (get from https://openrouter.ai/keys)
export OPENROUTER_API_KEY="your-api-key-here"

# Optional: Override default models
# export OPencode_MODEL_FAST="deepseek/deepseek-chat-v3-0324:free"
# export OPencode_MODEL_SMART="google/gemini-2.5-flash"
# export OPencode_MODEL_REASONING="openai/gpt-5"
EOF

# Initialize pre-commit
echo -e "${YELLOW}🪝 Setting up pre-commit hooks...${NC}"
# Note: pre-commit is managed by nix, hooks will be available in dev shell

echo
echo -e "${GREEN}✅ Project created successfully!${NC}"
echo
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. cd ${PROJECT_NAME}"
echo -e "  2. Copy .envrc.local.example to .envrc.local and add your OPENROUTER_API_KEY"
echo -e "  3. Run: direnv allow"
echo -e "  4. Run: nix develop"
echo -e "  5. Start coding with: opencode or claude"
echo
echo -e "${BLUE}Available commands in dev shell:${NC}"
echo -e "  /nix-flake-check     - Run all flake checks"
echo -e "  /test-run            - Run tests"
echo -e "  /sec-scan            - Security scan"
echo -e "  /changelog-add       - Add changelog entry"
echo -e "  /git-feature-start   - Start new feature branch"
echo
echo -e "${GREEN}Happy coding with AI assistance! 🤖${NC}"