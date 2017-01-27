#!/usr/bin/env bash
set -e

composer selfupdate
composer config github-oauth.github.com "$GITHUB_AUTH_TOKEN"
composer install --ignore-platform-reqs --no-interaction --prefer-dist
