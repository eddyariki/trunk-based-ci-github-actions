#!/bin/bash

# Fetch the latest tag from the main branch
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)

# Extract major, minor, patch version numbers
IFS='.' read -r -a version_parts <<< "${latest_tag//v/}"

major=${version_parts[0]}
minor=${version_parts[1]}
patch=${version_parts[2]}

# Get the commit message of the latest commit
commit_message=$(git log -1 --pretty=%B)

# Determine the new version based on the commit message
if [[ $commit_message == *"MAJOR"* ]]; then
  major=$((major + 1))
  minor=0
  patch=0
elif [[ $commit_message == *"MINOR"* ]]; then
  minor=$((minor + 1))
  patch=0
elif [[ $commit_message == *"PATCH"* ]]; then
  patch=$((patch + 1))
else
  patch=$((patch + 1))
fi

# Construct the new tag
new_tag="v$major.$minor.$patch-dev-$(git rev-parse --short HEAD)"

# Output the new tag
echo "New tag: $new_tag"

# Create the new tag
git tag $new_tag
git push origin $new_tag
