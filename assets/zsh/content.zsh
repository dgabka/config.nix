autoload -z edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line

bindkey '^ ' autosuggest-accept

function fzf-grep-widget {
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="$1"
  : | fzf -d 100% -- --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window '60%,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2})' \
    --height 100%
}
zle -N fzf-grep-widget
# CTRL+ALT+F
bindkey '^[^F' fzf-grep-widget

PATH=$HOME/.npm/bin:$PATH

function _just_wt_branches {
  local -a refs branches
  local ref

  git rev-parse --git-dir >/dev/null 2>&1 || return 1

  refs=("${(@f)$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin 2>/dev/null)}")
  for ref in "${refs[@]}"; do
    [[ "$ref" == "origin/HEAD" ]] && continue
    branches+=("${ref#origin/}")
  done

  branches=("${(@ou)branches}")
  (( ${#branches[@]} > 0 )) || return 1

  compadd -- "${branches[@]}"
}

function _just_wt_comp {
  local recipe="${words[2]-}"

  if (( CURRENT == 3 )); then
    case "$recipe" in
      wt|wt-path|wt-rm|wt-rm-force)
        _just_wt_branches && return 0
        ;;
    esac
  fi

  if (( CURRENT == 4 )) && [[ "$recipe" == "wt" ]]; then
    _just_wt_branches && return 0
  fi

  if (( $+functions[_just] )); then
    _just "$@"
    return
  fi

  _files
}

compdef _just_wt_comp just
