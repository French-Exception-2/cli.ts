param(
    [string] $Upstream = "upstream",
    [string] $UpstreamBranch = "develop",
    [string] $Origin = "origin",
    [string] $OriginBranch = "develop"
)
# Origin = origin = your cloned repository
# Origin = upstream = the repository you have forked

Git fetch $Upstream
git fetch $Origin
git checkout -b $Origin/$OriginBranch
Git pull --rebase $Upstream/$UpstreamBranch
Git push $Origin $OriginBranch --force 
