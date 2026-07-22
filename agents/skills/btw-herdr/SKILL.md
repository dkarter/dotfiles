---
name: btw-herdr
description: Launch a side-task agent in an adjacent Herdr pane without abandoning the current task. Use when the user invokes `/btw-herdr` or asks to send an aside, tangent, or parallel prompt to a new Herdr agent using the same harness as the caller. Requires HERDR_ENV=1.
---

# BTW Herdr

Pass the user's complete text after `/btw-herdr` to the launcher:

```bash
"<skill-directory>/scripts/launch" '<prompt>'
```

The launcher detects the current pane's agent kind, splits an adjacent pane
without changing focus, and starts and prompts the same harness asynchronously.

After the launcher returns:

- Briefly report the returned pane ID.
- Immediately continue the task that was in progress before `/btw-herdr`.
- Do not wait for, monitor, read, or summarize the side agent unless the user
  later asks.
- Do not delegate any part of the current task to the side agent.

If the launcher fails, report its error and continue the current task when safe.
