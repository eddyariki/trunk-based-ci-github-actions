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

# Determine the commit message of the merge commit
commit_message=$(git log -1 --pretty=%B)
echo "Commit message: $commit_message"

# Determine which part of the version to increment
if [[ "$commit_message" == *"MAJOR"* ]]; then
  major=$((major + 1))
  minor=0
  patch=0
elif [[ "$commit_message" == *"MINOR"* ]]; then
  minor=$((minor + 1))
  patch=0
else
  patch=$((patch + 1))
fi

# Construct the new tag
new_tag="v$major.$minor.$patch"

echo "New main tag:  $new_tag"

echo "new_tag=$new_tag" >> $GITHUB_ENV
