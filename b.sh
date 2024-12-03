#!/bin/bash

# 🕵️‍♂️ Check if inside a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "❌ This script must be run inside a Git repository."
  exit 1
fi

# 🕵️‍♂️ Check if fzf (fuzzy finder) is installed
if ! [ -x "$(command -v fzf)" ]; then
  # 🍺 Check if Homebrew is available
  if [ -x "$(command -v brew)" ]; then
    # 🛠️ Install fzf using Homebrew if it is not installed
    echo "🔍 fzf not found! Installing with Homebrew..."
    brew install fzf
  else
    # ❌ Print a message explaining how to install fzf manually
    echo "❌ fzf is not installed. To install it, please follow the instructions at https://github.com/junegunn/fzf#using-git"
    exit 1
  fi
fi

# 📜 Use `git reflog` to get a list of all branch names that were checked out
# 🔍 Use `grep` to filter out only the lines that contain the string "checkout: moving from"
# ✂️ Use `sed` to extract the branch name from each line
# 🔄 Get only unique branch names (without reordering)
branches=$(git reflog | grep "checkout: moving from" | sed -E "s/.*moving from ([^ ]*) to.*/\1/" | awk '!seen[$0]++')

# ❓ Check if any branches were found
if [ -z "$branches" ]; then
  echo "❌ No branches found in the reflog. Exiting script."
  exit 1
fi

# 🧙‍♂️ Use fzf to let the user select a branch from the list
selected_branch=$( \
  echo "$branches" | \
  fzf --prompt="🧙‍♂️ Select a branch to checkout: " \
      --height 10 \
      --border \
      --preview="git log --pretty=format:\"%C(yellow)%h%Creset %ad | %Cgreen%s%Creset %Cred%d%Creset %Cblue[%an]\" --date=short {}" \
      )

# ❓ Check if a branch was selected
if [ -z "$selected_branch" ]; then
  # ❌ Print an error message if no branch was selected
  echo "❌ No branch was selected. Exiting script."
  exit 1
fi

# 🚀 Checkout the selected branch
if ! git checkout $selected_branch; then
  echo "❌ Failed to checkout branch: $selected_branch"
  exit 1
fi

# 🎉 Print a success message
echo "✅ Successfully checked out branch: $selected_branch"