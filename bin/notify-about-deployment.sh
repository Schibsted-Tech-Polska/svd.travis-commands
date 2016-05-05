#!/usr/bin/env bash
set -e

__TIME_STOP=`date +%s`
_TIME=$((__TIME_STOP - __TIME_START))
_TIME_MIN=$((_TIME / 60))
_TIME_SEC=$((_TIME % 60))
BUILD_RESULT="$1"
BUILD_URL="https://travis.schibsted.io/$TRAVIS_REPO_SLUG/builds/$TRAVIS_BUILD_ID"
COMMIT_AUTHOR=`git show -s --format='%an' $TRAVIS_COMMIT`
COMMIT_CHANGELOG=`git show --stat $TRAVIS_COMMIT_RANGE`
COMMIT_DESCRIPTION=`git show -s --format='%s' $TRAVIS_COMMIT`
COMMIT_HASH="${TRAVIS_COMMIT:0:7}"
COMMIT_RANGE_URL="https://github.schibsted.io/$TRAVIS_REPO_SLUG/compare/$TRAVIS_COMMIT_RANGE"
if [ "$TRAVIS_BRANCH" == "$_STAGE_BRANCH" ]; then
	ENVIRONMENT_NAME="$_STAGE_ENVIRONMENT"
elif [ "$TRAVIS_BRANCH" == "$_PRODUCTION_BRANCH" ]; then
	ENVIRONMENT_NAME="$_PRODUCTION_ENVIRONMENT"
else
	ENVIRONMENT_NAME="unknown"
fi
REPOSITORY_NAME=`git config --get remote.origin.url | sed -nr 's/^.*[\/:](.*)\.git/\1/p'`
SLACK_MESSAGE_CHANNEL="#notifications-deploy"
SLACK_MESSAGE_COLOR="$2"
SLACK_MESSAGE_ICON="https://a.slack-edge.com/ae7f/img/services/travis_512.png"
SLACK_MESSAGE_TEXT="Build <$BUILD_URL|#$TRAVIS_BUILD_NUMBER> $BUILD_RESULT in $_TIME_MIN min $_TIME_SEC sec\n$COMMIT_AUTHOR deployed $TRAVIS_BRANCH@$REPOSITORY_NAME revision <$COMMIT_RANGE_URL|$COMMIT_HASH>\n$COMMIT_DESCRIPTION"
SLACK_MESSAGE_USERNAME="Travis CI"


if [ "$TRAVIS_BRANCH" == "$_PRODUCTION_BRANCH" ]; then
    curl https://api.newrelic.com/deployments.xml \
        --data-urlencode "deployment[app_name]=$NEWRELIC_APP_NAME" \
        --data-urlencode "deployment[changelog]=$COMMIT_CHANGELOG" \
        --data-urlencode "deployment[description]=$COMMIT_DESCRIPTION" \
        --data-urlencode "deployment[revision]=$TRAVIS_COMMIT" \
        --data-urlencode "deployment[user]=$COMMIT_AUTHOR" \
        --header "x-api-key:$NEWRELIC_NOTIFICATION_TOKEN"
else
  echo "skipped: notifying newrelic"
fi

# temporary solution: currently it's done at heroku side as deploy hook
#if [ "$TRAVIS_BRANCH" == "$_PRODUCTION_BRANCH" ] || \
#    [ "$TRAVIS_BRANCH" == "$_STAGE_BRANCH" ]; then
#    curl https://api.rollbar.com/api/1/deploy/ \
#        --data-urlencode "access_token=$ROLLBAR_NOTIFICATION_TOKEN" \
#        --data-urlencode "comment=$COMMIT_DESCRIPTION" \
#        --data-urlencode "environment=$ENVIRONMENT_NAME" \
#        --data-urlencode "local_username=$COMMIT_AUTHOR" \
#        --data-urlencode "revision=$TRAVIS_COMMIT"
#else
#  echo "skipped: notifying rollbar"
#fi

if [ "$TRAVIS_BRANCH" == "$_PRODUCTION_BRANCH" ] || \
    [ "$TRAVIS_BRANCH" == "$_STAGE_BRANCH" ]; then
    curl https://hooks.slack.com/services/$SLACK_NOTIFICATION_TOKEN \
        --data-urlencode "payload={
            \"attachments\": [
                {
                    \"color\": \"$SLACK_MESSAGE_COLOR\",
                    \"text\": \"$SLACK_MESSAGE_TEXT\"
                }
            ],
            \"channel\": \"$SLACK_MESSAGE_CHANNEL\",
            \"icon_url\": \"$SLACK_MESSAGE_ICON\",
            \"username\": \"$SLACK_MESSAGE_USERNAME\"
        }" \
        --request POST
else
  echo "skipped: notifying slack"
fi
