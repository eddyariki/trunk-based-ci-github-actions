#!/bin/bash

# Fetch all tags and filter out those containing -dev or -stg
latest_tag=$(git tag -l | grep -vE "(-dev|-stg)" | sort -V | tail -n 1)

# If no tags exist, set the default tag to v0.1.0
if [ -z "$latest_tag" ]; then
  latest_tag="v0.1.0"
fi

# Extract major, minor, patch version numbers
IFS='.' read -r -a version_parts <<< "${latest_tag//v/}"

major=${version_parts[0]}
minor=${version_parts[1]}
patch=${version_parts[2]}

# Get the commit message of the latest commit in the PR branch
commit_message=$(git log -1 --pretty=%B HEAD)

# Debugging: print the commit message
echo "Commit message: $commit_message"

# Determine the new version based on the commit message
if [[ $commit_message == *"MAJOR"* ]]; then
  major=$((major + 1))
  minor=0
  patch=0
  echo "Incrementing major version"
elif [[ $commit_message == *"MINOR"* ]]; then
  minor=$((minor + 1))
  patch=0
  echo "Incrementing minor version"
elif [[ $commit_message == *"PATCH"* ]]; then
  patch=$((patch + 1))
  echo "Incrementing patch version"
else
  patch=$((patch + 1))
  echo "Defaulting to patch increment"
fi

# Construct the new tags
new_dev_tag="v$major.$minor.$patch-dev-$(git rev-parse --short HEAD)"
new_stg_tag="v$major.$minor.$patch-stg-$(git rev-parse --short HEAD)"

# Output the new tags
echo "New dev tag: $new_dev_tag"
echo "New stg tag: $new_stg_tag"

# Create the new tags
git tag $new_dev_tag
git tag $new_stg_tag
