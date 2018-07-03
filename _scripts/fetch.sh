declare -r SSH_FILE="$(mktemp -u $HOME/.ssh/XXXXX)"
# Decrypt the file containing the private key
       openssl aes-256-cbc \
         -K $encrypted_bfaa3cf3ea33_key \
         -iv $encrypted_bfaa3cf3ea33_iv \
         -in ".travis/github_deploy_key.enc" \
         -out "$SSH_FILE" -d
       # Enable SSH authentication
       chmod 600 "$SSH_FILE" \
         && printf "%s\n" \
              "Host github.com" \
              "  IdentityFile $SSH_FILE" \
              "  LogLevel ERROR" >> ~/.ssh/config

git config --global user.email "$COMMIT_EMAIL"
git config --global user.name "wdzajicek"
# Keep track of where Travis put us.
# We are on a detached head, and we need to be able to go back to it.
function create_all_branches()
{
  local build_head=$(git rev-parse HEAD)

  # Fetch all the remote branches. Travis clones with `--depth`, which
  # implies `--single-branch`, so we need to overwrite remote.origin.fetch to
  # do that.
  git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
  git fetch
  # optionally, we can also fetch the tags
  git fetch --tags

  # create the tacking branches
  for branch in $(git branch -r|grep -v HEAD) ; do
    git checkout -qf ${branch#origin/}
  done
}

create_all_branches

# finally, go back to where we were at the beginning
git checkout ${build_head}

git checkout master
git merge
git checkout cloudcannon
git merge
git checkout master
git merge cloudcannon -m "Travis merge of cloudcannon to master branch"
git remote add origin https://${GH_TOKEN}@github.com/kankakeecommunitycollege/deployment-newsroom.git > /dev/null 2>&1
git push -u origin master
