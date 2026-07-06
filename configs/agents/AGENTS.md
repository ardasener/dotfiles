# Agentic Workflow Guidelines

Use this file as the shared coding and workflow baseline for Codex, OpenCode, and Copilot.

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

## 5. Workflow Guidance
- Check the repository README and any project-local `Agents.md` or `AGENTS.md` before implementing.
- Keep application logic modular and aligned with explicit boundaries.
- Do not write tests unless explicitly asked to do so.
- After a major change, run available compile checks and static checkers.
- If tests exist, run the relevant test suite too.
- For reviews, lead with concrete defects and regressions, not style-only commentary.
- For tests, cover behavior, edge cases, regressions, and key integration paths.

Defaults can be overridden by project-local `Agents.md` or `AGENTS.md` files.

<!-- context7 -->
Use the `ctx7` CLI to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service -- even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer -- your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Resolve library: `npx ctx7@latest library <name> "<user's question>"` — use the official library name with proper punctuation (e.g., "Next.js" not "nextjs", "Customer.io" not "customerio", "Three.js" not "threejs")
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question)
3. Fetch docs: `npx ctx7@latest docs <libraryId> "<user's question>"`
4. Answer using the fetched documentation

You MUST call `library` first to get a valid ID unless the user provides one directly in `/org/project` format. Use the user's full question as the query -- specific and detailed queries return better results than vague single words. Do not run more than 3 commands per question. Do not include sensitive information (API keys, passwords, credentials) in queries.

For version-specific docs, use `/org/project/version` from the `library` output (e.g., `/vercel/next.js/v14.3.0`).

If a command fails with a quota error, inform the user and suggest `npx ctx7@latest login` or setting `CONTEXT7_API_KEY` env var for higher limits. Do not silently fall back to training data.
Run Context7 CLI requests outside Codex's default sandbox. If a Context7 CLI command fails with DNS or network errors such as ENOTFOUND, host resolution failures, or fetch failed, rerun it outside the sandbox instead of retrying inside the sandbox.
<!-- context7 -->
