---
name: code-walkthrough
description: Guide a visible, verified code walkthrough in a Herdr-managed Neovim pane with Navi, optionally recording the presentation with OBS. Use when the user wants an agent-led code tour, code-along, live source explanation, or recorded terminal walkthrough.
---

# Code Walkthrough

Use a **verified tour**: establish the real code and output first, then guide attention through one immutable Navi tour.

## Prepare The Session

1. Confirm `HERDR_ENV=1`. If it is not, say that the walkthrough requires Herdr and stop.
2. Run `herdr pane list --workspace "$HERDR_WORKSPACE_ID"`, check plausible panes with `herdr pane process-info --pane <pane-id>`, and use the sole pane whose foreground process is `nvim`. If multiple Neovim panes exist, use the pane the user identified or ask instead of guessing. Verify it once with `herdr pane read <pane-id> --source visible`. Reuse that Neovim process; do not exit or restart it.
3. Do not preflight Neovim, Navi, or Herdr versions. Attempt the real workflow first; inspect versions or installation only if loading fails with a compatibility or missing-command error.
4. Resize before composing the tour only when the current viewport is too narrow. Keep the size stable while presenting or recording.

The session is ready when the human and agent see the same settled Neovim screen and the agent can read and drive that exact pane through Herdr.

## Establish The Journey

1. Ask what the viewer should understand or be able to explain afterward when the outcome is unclear.
2. Read only the files needed for the journey and run the narrowest command that proves its current behavior.
3. Inspect the actual visible result. Do not write notes from an expected or remembered result.
4. Choose one conceptual journey. A useful journey often moves from public behavior to the mechanism that produces it, then to the observed result.

Do not combine an overview, failure diagnosis, implementation tour, and fix into one sequence. The journey is established when each planned stop is necessary to answer one coherent question.

## Author One Immutable Tour

Create a JSON file outside the source tree when the tour is temporary. Use absolute file paths so resolution does not depend on Neovim's working directory. Use literal patterns when they are unique and stable; use line numbers only when exact positions are the point.

```json
[
  {
    "file": "/absolute/path/to/project/src/example.test.ts",
    "pattern": "it(\"updates subscribers\"",
    "end_pattern": "expect(runs).toBe(2)",
    "message": "The public contract starts here: one write must cause one additional run."
  },
  {
    "file": "/absolute/path/to/project/src/example.ts",
    "pattern": "export function notify",
    "end_pattern": "subscriber()",
    "message": "The implementation reaches every subscriber through this loop."
  }
]
```

Load it without modifying it. With Herdr, send the command to the existing Neovim pane and read the resulting viewport:

```bash
herdr pane send-keys <pane-id> escape
herdr pane send-text <pane-id> ':NaviLoad /absolute/path/to/tour.json'
herdr pane send-keys <pane-id> enter
herdr pane read <pane-id> --source visible
```

For a human-controlled session, the underlying Neovim command is:

```vim
:NaviLoad /absolute/path/to/tour.json
```

Apply these rules:

- Create at most one tour per assistant response.
- Treat a shown tour as immutable. Do not rewrite its stops or notes in the same response.
- Start at the behavior or call site before entering implementation details.
- Use one range stop for adjacent lines that form one simple mechanism.
- Use multiple stops only for a genuine journey between distinct locations.
- Put most of the explanation in short, casual Navi notes; keep chat brief.
- Keep concise verified output at the decisive assertion or result when it helps explain the behavior.
- Treat successful `:NaviLoad` and traversal as the Navi readiness check. Do not run separate version or command-existence probes unless loading fails.
- Validate every stop by navigating to it and reading the visible viewport. Return to the first stop and verify it is visible before handing control to the viewer.
- Avoid broad CI and unrelated repository checks. Run only commands that provide evidence required by the walkthrough.
- If verification disproves the explanation, stop and say so. Clear or replace the tour only in the next response.

The tour is complete when every stop resolves, the first stop is visible, and its notes agree with the verified code and output.

## Present The Tour

Let the viewer control the pace unless asked to drive:

```text
]n           next stop
[n           previous stop
<leader>np  pick a stop
<leader>nc  clear the tour
```

These are recommended mappings, not Navi defaults. If they are unavailable, use `:NaviNext`, `:NaviPrev`, `:NaviPick`, and `:NaviClear`.

Pause for questions without replacing the active tour. A follow-up explanation may focus the current range or inspect output, but a different conceptual journey belongs in a later tour.

## Record With OBS

Use OBS when the desired artifact is the human-facing presentation, including natural pacing, narration, window chrome, or other visual context.

1. Add a Window Capture source for the terminal window containing the visible Neovim pane.
2. Crop unrelated tabs, prompts, notifications, and private paths before recording.
3. Set the terminal size, font size, OBS canvas, and capture crop before authoring the tour so notes wrap exactly as they will in the recording.
4. Perform a short test recording. Verify text legibility, microphone level, terminal contrast, and that Navi notes fit without clipping.
5. Start OBS recording, present the immutable tour, then stop recording after the final frame has held long enough to read.

OBS is the recording surface. Herdr remains the agent-control and verification surface.

## Finish

Clear the tour unless the user wants it left open:

```vim
:NaviClear
```

Do not stop or close the reused Herdr pane.

Report the verified behavior, the journey presented, and any retained artifact paths. The walkthrough is complete when the viewer has traversed the journey, the terminal session has the requested final state, and every promised artifact has been checked.

## Tool References

- Herdr: <https://herdr.dev>
- Navi: <https://github.com/kitlangton/navi.nvim>
