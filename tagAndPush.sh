#!/bin/bash

# Read the version from pubspec.yaml
# and remove potential carriage returns and leading/trailing whitespace
VERSION=$(grep 'version: ' pubspec.yaml | sed 's/version: //' | tr -d '\r' | xargs)

# Fallback: A more aggressive cleanup if needed, but be cautious
# VERSION=$(grep 'version: ' pubspec.yaml | sed 's/version: //' | tr -d '\r' | sed 's/[^a-zA-Z0-9.+_ -]//g' | xargs)


# Ensure VERSION is not empty
if [ -z "$VERSION" ]; then
  echo "Error: Could not extract version from pubspec.yaml"
  exit 1
fi

echo "Extracted version: '$VERSION'" # For debugging

# Create a Git tag
git tag "v$VERSION"
if [ $? -ne 0 ]; then
  echo "Error: Failed to create git tag 'v$VERSION'"
  exit 1
fi

# Push the tag to the remote repository
git push origin "v$VERSION"
if [ $? -ne 0 ]; then
  echo "Error: Failed to push git tag 'v$VERSION' to origin"
  exit 1
fi

echo "Successfully tagged and pushed v$VERSION"