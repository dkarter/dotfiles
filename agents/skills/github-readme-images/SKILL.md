---
name: github-readme-images
description: Use when adding screenshots or other images to a GitHub README. Prefer hosting them in a repository issue rather than committing image files.
---

# GitHub README images

For terminal captures, use `tui-shot --pane "$pane" -o screenshot.png`.
Review images for private data before uploading.

Reuse or create a dedicated gallery issue in the same repository. Attach the
images to a comment with descriptive alt text:

```sh
gh issue comment "$issue" --repo "$repo" --body "README images" \
  --attach 'screenshot.png#Describe what the screenshot shows'
```

Repeat `--attach` for multiple files. Copy the generated image Markdown from
the posted comment into the README and check that its URLs load for the
README's intended audience. If `--attach` is unavailable, use the issue's web
editor. Keep image files out of Git unless the project needs them there.
