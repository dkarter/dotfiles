# disable skills.sh telemetry
export SKILLS_NO_TELEMETRY=1

# add-skill - Add a Claude Code skill and remove its .git directory
#
# Wraps `bunx skills add` to automatically remove the embedded git repository
# so the skill can be committed to your dotfiles without submodule issues.
#
# You can find skills in https://skills.sh
#
# Usage:
#   add-skill <owner/repo> [--skill <name>]
#
# Example:
#   add-skill blader/humanizer --skill "humanizer"
add-skill() {
  if [[ -z $1 ]]; then
    echo "Usage: add-skill <owner/repo> [--skill <name>]"
    return 1
  fi

  # Run the original bunx skills add command
  bunx skills add "$@"

  # Extract the skill name from arguments
  local skill_name
  local found_skill=0
  if [[ $* == *"--skill"* ]]; then
    # Parse --skill argument
    for i in "$@"; do
      if [[ $found_skill == 1 ]]; then
        skill_name="$i"
        break
      fi
      if [[ $i == "--skill" ]]; then
        found_skill=1
      fi
    done
  else
    # Default to repo name (last part after /)
    skill_name="${1##*/}"
  fi

  # Find the skill in either location (home or dotfiles)
  local skill_path
  if [[ -d "${HOME}/.config/opencode/skills/${skill_name}" ]]; then
    skill_path="${HOME}/.config/opencode/skills/${skill_name}"
  elif [[ -d "config/opencode/skills/${skill_name}" ]]; then
    skill_path="config/opencode/skills/${skill_name}"
  else
    echo "Could not find skill directory for '${skill_name}'"
    return 1
  fi

  # Remove .git directory if it exists
  if [[ -d "${skill_path}/.git" ]]; then
    echo "Removing .git directory from ${skill_path}..."
    rm -rf "${skill_path}/.git"
    echo "Done! Skill is now ready to commit to your dotfiles."
  else
    echo "No .git directory found in ${skill_path}"
  fi
}
