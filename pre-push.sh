#!/bin/bash
# Git pre-push hook to generate changelog.
#
# Copy this file to .git/hooks/pre-push

just generate-changelog
# Scoped to the changelog on purpose: `-a` would sweep every other modified
# tracked file into this commit.
git commit -m "chore: update changelog" CHANGELOG.md || true
exit 0
