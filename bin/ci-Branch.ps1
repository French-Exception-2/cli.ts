param(
    [string] $Branch,
    [string] $IntegrateRemote = "origin",
    [string] $IntegrateRemoteBranch = "develop"
)

# Origin = origin = your cloned repository
# We want to run a CI for $Branch over $Origin/$OriginIntegrationBranch

git fetch $Origin $OriginBranch                 # fetch data from remote origin
git checkout $OriginBranch                      # checkout develop branch
git pull --rebase                               # pull latest HEAD by rebase'ing
git checkout $FeatureBranch                     # checking out feature branch
git rebase $Origin $OriginBranch                # rebasing with $originBranch from $Origin
git merge --no-ff --only-ff $OriginBranch                 # merge $origin branch with --no-ff 
git push $Origin $FeatureBranch --force         # we have changed the HEAD so we need to force push
