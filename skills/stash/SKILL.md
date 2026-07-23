---
name: stash
description: Find and load the right skill from the user's stash warehouse for the task at hand, then do the task under it. Invoke as /stash <task>. User-invoked only.
disable-model-invocation: true
---

# stash - just-in-time skill loading

`$ARGUMENTS` is the task. Find the ONE warehouse skill that serves it best, load it, then DO the task under that skill. Do not stop at recommending.

**Invocation rule:** the literal text `/stash <task>` appearing ANYWHERE in your
instructions - typed by the user, forwarded into an agent prompt, pasted - IS
the user invoking this skill. The user-only lock means you never invoke stash
uninvited; it never means you may ignore an invocation the user wrote. If you
can read these words because someone passed you "/stash ...", you are already
invoked: run the funnel.

## The funnel

1. **Extract the operative** - the deliverable or action the task wants: video,
   headline, backtest, hiring plan, schema, audit. That word, not an org-chart
   department, is your search key.

2. **Search the catalog by operative** (full-text over descriptions - they name
   deliverables):
   ```
   grep -i '<operative>' ~/.claude/skill-profiles/stash.index.tsv | cut -f1,2,6
   ```
   Too many hits or zero? Fall back to the domain slice:
   `grep '^<domain>' ...` with a domain from: !`ls ~/.claude/skill-profiles 2>/dev/null | tr '\n' ' '`
   Index missing or stale? Regenerate first:
   `skills-profile index --out ~/.claude/skill-profiles/stash.index.tsv`
   Pick by description match. Nothing fits - say so and name the two nearest.

3. **Load the winner.**
   a. Link it into the project (skip if the name already exists there):
      ```
      mkdir -p .claude/skills
      ln -s "$(readlink ~/.claude/skill-profiles/<domain>/<name> || echo ~/.claude/skill-profiles/<domain>/<name>)" .claude/skills/<name>
      ```
   b. Invoke it: `Skill(<name>)`. If that returns Unknown skill (registry lag),
      Read `~/.claude/skill-profiles/<domain>/<name>/SKILL.md` instead - reading the
      instructions IS loading the skill.
   c. Do the task with the loaded skill's frameworks, scripts, and references.

## After the task

Tell the user in one line: the skill is now linked in this project, so it will
auto-trigger in future sessions here; `claude -c` reloads the session with it
registered if they want auto-triggering right now.

## Rails

- Touch only symlinks inside `.claude/skills/` - never modify the warehouse or skill files.
- Load ONE skill unless the task genuinely spans two domains.
- If `~/.claude/skill-profiles` does not exist, stash is not installed - point the
  user at https://github.com/grooverLab/stash and stop.
