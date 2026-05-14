---
description: Initialize Spec Kit for this repository
agent: Architect
---

!`if command -v specify >/dev/null 2>&1; then specify init --here --integration opencode && specify extension add iterate --from https://github.com/imviancagrace/spec-kit-iterate; else printf '%s\n' 'specify is not found. Install it with: pipx install git+https://github.com/github/spec-kit.git'; fi`

`/speckit.init`
