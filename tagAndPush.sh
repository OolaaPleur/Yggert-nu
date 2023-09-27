#!/bin/bash

# Read the version from pubspec.yaml
VERSION=$(grep 'version: ' pubspec.yaml | sed 's/version: //')

# Remove any spaces
VERSION=$(echo $VERSION | xargs)

# Create a Git tag
git tag "v$VERSION"

# Push the tag to the remote repository
git push origin "v$VERSION"
