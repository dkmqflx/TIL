# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **Today I Learned (TIL)** repository for documenting development experiences and learning outcomes. It's a markdown-based documentation repository organized by topic and technology.

## Folder Structure

The repository is organized by category and technology domain:

```
til/
├── frontend/          # Frontend-related topics
│   ├── a11y/         # Accessibility
│   ├── css/
│   ├── dp/           # Design Patterns (React)
│   ├── env/          # Frontend development environment
│   ├── html/
│   ├── i18n/         # Internationalization
│   ├── interactive-web/
│   ├── js/           # JavaScript
│   ├── next/         # Next.js
│   ├── opt/          # Optimization
│   ├── react/
│   ├── rn/           # React Native
│   ├── test/         # Frontend testing
│   └── ts/           # TypeScript
├── backend/           # Backend-related topics
│   ├── nodejs/
│   ├── nestjs/
│   ├── fastapi/
│   ├── postgresql/
│   ├── supabase/
│   └── interview/    # Interview prep
├── cs/                # Computer Science
│   └── network/
├── infra/             # Infrastructure & DevOps
│   ├── aws/
│   ├── cicd/
│   ├── docker/
│   ├── git/
│   └── linux/
├── ai/                # AI & ML topics
├── clean-code/        # Code quality & best practices
├── seo/               # Search Engine Optimization
└── product-engineer/  # Product engineering
```

## Git Workflow

### Commit Message Rules

This repository uses **commitlint** to enforce standardized commit messages. All commits are validated by git hooks (husky) before being committed.

**Commit Format:**
```
<type>(<scope>): <subject>
```

**Type:** One of `add`, `update`, `fix`, `refactor`, `delete`

**Scope:** Must be one of the following (category(subcategory) format):
- Frontend: `fe(a11y)`, `fe(css)`, `fe(dp)`, `fe(env)`, `fe(html)`, `fe(i18n)`, `fe(interactive-web)`, `fe(js)`, `fe(next)`, `fe(opt)`, `fe(react)`, `fe(rn)`, `fe(test)`, `fe(ts)`
- Backend: `be(nodejs)`, `be(nestjs)`, `be(fastapi)`, `be(postgresql)`, `be(supabase)`, `be(interview)`
- Computer Science: `cs(network)`
- Infrastructure: `infra(aws)`, `infra(cicd)`, `infra(docker)`, `infra(git)`, `infra(linux)`
- Independent categories: `ai`, `clean-code`, `seo`

**Examples:**
```bash
git commit -m "add(fe(react)): new component documentation"
git commit -m "update(be(nodejs)): Node.js best practices"
git commit -m "fix(fe(ts)): TypeScript generics explanation"
git commit -m "refactor: reorganize folder structure"
```

### Installation & Setup

To set up git hooks:
```bash
npm install
```

This installs husky and configures pre-commit hooks for commit message validation.

## Development Guidelines

1. **One file per topic** - Each markdown file documents a specific concept, technique, or learning outcome
2. **Link structure** - Use relative links to cross-reference related documentation
3. **Keep it organized** - Place documentation in the appropriate folder category
4. **Update selectively** - Only modify or add documentation when you have meaningful new information to contribute
