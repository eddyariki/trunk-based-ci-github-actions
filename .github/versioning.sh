#!/bin/bash

latest_tag=$(git tag -l | grep -vE "(-dev|-stg)" | sort -V | tail -n 1)

if [ -z "$latest_tag" ]; then
  latest_tag="v0.1.0"
fi

IFS='.' read -r -a version_parts <<< "${latest_tag//v/}"

major=${version_parts[0]}
minor=${version_parts[1]}
patch=${version_parts[2]}

base_branch=$GITHUB_BASE_REF

head_branch=$GITHUB_HEAD_REF

git checkout $head_branch

commit_message=$(git log -1 --pretty=%B)

echo "Commit message: $commit_message"

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

new_dev_tag="v$major.$minor.$patch-dev-$(git rev-parse --short HEAD)"
new_stg_tag="v$major.$minor.$patch-stg-$(git rev-parse --short HEAD)"

echo "New dev tag: $new_dev_tag"
echo "New stg tag: $new_stg_tag"

echo "new_dev_tag=$new_dev_tag" >> $GITHUB_ENV
echo "new_stg_tag=$new_stg_tag" >> $GITHUB_ENV
