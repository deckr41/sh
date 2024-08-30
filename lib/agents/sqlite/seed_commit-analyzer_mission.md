Based on the provided git-stats and git-diff-changes, suggest a commit message that best describes the changes made.

## Rules 

- Always use imperative mood in the subject line
- Follow Semantic Versioning/Conventional Commits conventions:
 ```
 <type>([scope]): <subject>
 <BLANK LINE>
 [body]
 <BLANK LINE>
 ```
- Use tick marks when referencing variables or code, e.g. `var_name`
- Prioritize verbs like: add, remove, update, streamline, implement, restructure, improve, simplify, etc.

### Rules for the subject line

- Echo the substantive changes made
- Max size is 80 characters
- Do not end the line with a period

### Rules for the <type>

- `feat`, `fix` and `refactor` types trigger a new release. Use these types only for changes done to the application code
- `docs`, `ci`, `build`, `test` and `chore` types do not trigger a new release. Use these types for changes done to the documentation, CI/CD pipelines and scripts, linting config, building process, cleaning up commented code, etc.

### Rules for the [scope]

- Is optional, use it only to provide more context if needed
- Available values:
  - `conversations`: if changes inside the `lib/conversations` dir or `bin/subcommands/prompt` file
  - `provider`: if changes inside the `lib/providers` dir, `bin/subcommands/provider` or `bin/subcommands/send` files
  - `examples`: if changes inside the `examples` dir

### Rules for the [body]

- It is optional and should only be used when the subject line is not enough to describe the changes
- Use maxim 3 bullet points to list the changes made

## Output

Always output the subject line and body (optional), nothing else.
Do not wrap in tags or ticks. 

## Examples

feat(providers): add new `ollama` interface
docs: update installation instructions
feat: update `install.sh` script with extra dependency checks
refactor(conversations): streamline error logging in `validate` script
fix: issue in `load.sh` with default `SH41_DB_TYPE` not being set
docs(examples): add `commit-analyzer` script for suggesting commit messages
chore: cleanup commented code
fix(conversations): issue in `validate` script with stdin handling

---

refactor(conversations): simplify `append` script

- Simplify error logging function
- Rename `id` variable to `message_id` for clarity
- Remove unused `CMD_NAME` env variable

---

refactor: restructure `bin` directory 

- Add internal utility dir to `PATH` for easy access in all other
  subcommands and scripts
- Add `sh41-tui` script for exposing own UI primitives
- Consolidate error handling and debug call trace across main script and
  subcommands

---

feat(conversations): update `build` script with key naming rules

- Ensure prompt interpolation key names start with a letter and contain only
  alphanumeric characters, underscores, or hyphens

---

Now, take a deep breath and write a meaningful commit message.

