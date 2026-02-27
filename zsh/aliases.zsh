# Gum / Git & You
alias gcopr="gh pr list | cut -f1,2,3 | gum choose | cut -f1 | xargs gh pr checkout"
alias gcomr="glab mr list | cut -f1,2,3 | gum choose | cut -f1 | xargs glab mr checkout"
alias gcob="git branch -r | grep -v 'HEAD' | sed 's/origin\///g' | gum choose | xargs git checkout"

alias ls="eza --icons"
alias ll="eza -lah --icons"

alias cd="z"

alias python="python3"

# Seed zoxide with "bucket" dirs and git repos under a base path
seed_zoxide_repos() {
  local base="${1:-$PWD}"

  if [[ ! -d "$base" ]]; then
    echo "Base path does not exist: $base" >&2
    return 1
  fi

  echo "Seeding zoxide from base: $base"
  echo

  # 1) Add top-level buckets (immediate child directories)
  echo "Adding bucket directories:"
  for dir in "$base"/*; do
    [[ -d "$dir" ]] || continue
    echo "  + $dir"
    zoxide add "$dir"
  done

  echo
  echo "Adding git repo roots:"
  # 2) Add any git repo roots under the base (1–3 levels deep)
  find "$base" -mindepth 1 -maxdepth 3 -type d -name .git -print0 \
    | while IFS= read -r -d '' gitdir; do
        local repo="${gitdir%/.git}"
        echo "  + $repo"
        zoxide add "$repo"
      done

  echo
  echo "✅ Done seeding zoxide from: $base"
}

aws-login() {
  if [[ "$1" == "-i" ]]; then
    profile=$(grep '^\[profile ' ~/.aws/config | sed 's/\[profile \(.*\)\]/\1/' | fzf)
  else
    profile="${1:-<UPDATE PROFILE WHEN DEPLOYED>}"
  fi

  [[ -z "$profile" ]] && return

  aws sso login --profile "$profile"
  aws sts get-caller-identity --profile "$profile"
}

alias tf="terraform"
alias tg="terragrunt"
alias tgd="AWS_PROFILE=dev tg"
alias tgdi="tgd init"
alias tgdp="tgd plan"
alias tgda="tgd apply"
alias aws-dev="AWS_PROFILE=dev aws sso login"
alias aws-shared="AWS_PROFILE=shared aws sso login"
