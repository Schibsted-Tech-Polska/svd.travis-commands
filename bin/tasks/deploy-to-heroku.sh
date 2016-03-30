#!/usr/bin/env bash
set -e

# skip this step if previous has failed
if [ "$TRAVIS_TEST_RESULT" = "1" ]; then
   exit;
fi
# add code BELOW this line

if [ "$TRAVIS_BRANCH" == "$_PRODUCTION_BRANCH" ]; then
	HEROKU_APP_NAME="$_PRODUCTION_HEROKU_APP"
elif [ "$TRAVIS_BRANCH" == "$_STAGE_BRANCH" ]; then
	HEROKU_APP_NAME="$_STAGE_HEROKU_APP"
else
	HEROKU_APP_NAME="unknown"
fi
HEROKU_CLIENT_DIR="$TRAVIS_BUILD_DIR/$TRAVIS_CACHE_DIR/heroku-client/bin"


if [ "$TRAVIS_REPO_SLUG" == "$REPOSITORY_SLUG" ] && \
    [ "$TRAVIS_PULL_REQUEST" == false ]; then
    if [ "$TRAVIS_BRANCH" == "$_PRODUCTION_BRANCH" ] || \
        [ "$TRAVIS_BRANCH" == "$_STAGE_BRANCH" ]; then
        $HEROKU_CLIENT_DIR/heroku git:remote -a $HEROKU_APP_NAME -r heroku

        git config --global push.default matching
        git push heroku $TRAVIS_BRANCH:master -f
    else
      echo "skipped: pushing to heroku"
    fi
else
  echo "skipped: pushing to heroku"
fi
