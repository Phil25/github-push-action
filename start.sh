#!/bin/sh
set -e

INPUT_BRANCH=${INPUT_BRANCH:-master}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
_FORCE_OPTION=''
REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}

echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

mkdir -v "/root/.ssh"
ssh-keyscan -t rsa github.com > "/root/.ssh/known_hosts"
echo "${INPUT_GITHUB_TOKEN}" > "/root/.ssh/id_rsa"
chmod 400 "/root/.ssh/id_rsa"

if ${INPUT_FORCE}; then
    _FORCE_OPTION='--force'
fi

cd ${INPUT_DIRECTORY}

remote_repo="git@github.com:${REPOSITORY}.git"

git remote rm origin || true
git remote add origin "${remote_repo}"

echo "Pushing to ${remote_repo}"
git push origin ${INPUT_BRANCH} --follow-tags $_FORCE_OPTION;
