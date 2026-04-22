# Agentic Workflow Guidelines

Use these shared role definitions when needed:
- `Architect`: `~/.config/ai-agents/Architect.md`
- `Developer`: `~/.config/ai-agents/Developer.md`
- `Tester`: `~/.config/ai-agents/Tester.md`
- `Researcher`: `~/.config/ai-agents/Researcher.md`
- `Reviewer`: `~/.config/ai-agents/Reviewer.md`

## 1. General Programming Standards
- Follow SOLID and DRY principles.
- Methods should do one thing and do it well.
- Prioritize intent over implementation.
- Use domain-driven names, for example `executeTrade` instead of `runProcess`.
- Avoid generic `Exception` or `RuntimeException`.
- Use specific, descriptive exceptions.
- Fail fast and provide meaningful error messages.
- Be mindful of time and space complexity, such as `O(n)` and `O(log n)`.
- Avoid early optimization, write clear code first, then optimize if necessary.
- Always account for nullability.
- Use `Optional` in Java or optional chaining in TypeScript.
- Keep comments minimal and document intent, not implementation.
- Use docstrings to explain the purpose of classes and methods, not how they work.

## 2. Response Protocol
- Skip preambles like "I understand", "I can help with that", or "Here is the code".
- Do not apologize for mistakes or ask for forgiveness; just correct them and move on.
- Start with the most important information or code block.
- Keep responses high-density and concise.
- Correct flawed logic directly and suggest the fix.
- Use Markdown for scannability.
- Use code blocks with appropriate language tags.
- After completing a task, keep the wrap-up to 1-2 sentences. 
- Do not make suggestions for next steps unless asked.

## 3. Logic & Math
- Double-check logic for off-by-one errors and boundary conditions.
- Use LaTeX for formal math or complex variables.

## 4. Security & Sustainability
- Sanitize inputs and parameterize queries by default.
- Ensure I/O streams, sockets, and native buffers are closed properly.
- Prefer standard libraries over OS-specific commands unless the OS matters.
- Avoid assuming the underlying OS unless specified.

Defaults can be overridden by project-local `Agents.md` or `AGENTS.md` files.
