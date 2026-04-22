{
  llm-agents,
  pkgs,
  lib,
  ...
}: let
  skillsDir = ../../../assets/skills;
  skillNames = builtins.filter (skill: (builtins.readDir skillsDir).${skill} == "directory") (builtins.attrNames (builtins.readDir skillsDir));
  forge = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.forge;
in {
  home.packages = [
    forge
  ];

  home.file = builtins.listToAttrs (
    map (skill: {
      name = ".agents/skills/${skill}";
      value.source = skillsDir + "/${skill}";
    })
    skillNames
  );

  programs.zsh.initContent = lib.mkAfter ''
    export FORGE_BIN="${lib.getExe forge}"
    source <($FORGE_BIN zsh plugin)

    # Allow RPROMPT to evaluate command substitutions at render time.
    setopt PROMPT_SUBST

    # Forge already knows how to build the right prompt, but it uses one set of
    # colors for the idle prompt and a different set while an active conversation
    # is attached. We keep the idle prompt untouched and only remap the active
    # prompt colors to the Sageveil palette.
    function _forge_prompt_info() {
      local raw_prompt
      local -a forge_cmd
      forge_cmd=("$FORGE_BIN" zsh rprompt)

      # Forward Forge's session-local overrides so the prompt always reflects the
      # currently selected model/provider/reasoning effort.
      [[ -n "$_FORGE_SESSION_MODEL" ]] && local -x FORGE_SESSION__MODEL_ID="$_FORGE_SESSION_MODEL"
      [[ -n "$_FORGE_SESSION_PROVIDER" ]] && local -x FORGE_SESSION__PROVIDER_ID="$_FORGE_SESSION_PROVIDER"
      [[ -n "$_FORGE_SESSION_REASONING_EFFORT" ]] && local -x FORGE_REASONING__EFFORT="$_FORGE_SESSION_REASONING_EFFORT"

      # Ask Forge to generate the prompt string. Passing COLUMNS preserves its own
      # truncation/layout logic when the terminal width changes.
      raw_prompt=$(_FORGE_CONVERSATION_ID=$_FORGE_CONVERSATION_ID _FORGE_ACTIVE_AGENT=$_FORGE_ACTIVE_AGENT COLUMNS=$COLUMNS "''${forge_cmd[@]}" 2>/dev/null)

      # Active prompts use Forge's bright numeric colors (%F{15}, %F{134}, %F{3}).
      # Replace only those tokens so the inactive prompt (%F{240}, etc.) stays as-is.
      if [[ "$raw_prompt" == *"%F{15}"* ]]; then
        raw_prompt=''${raw_prompt//\%F\{15\}/%F{#A8AFA6}}
        raw_prompt=''${raw_prompt//\%F\{134\}/%F{#9D868C}}
        raw_prompt=''${raw_prompt//\%F\{3\}/%F{#B4A05A}}
      fi

      print -r -- "$raw_prompt"
    }

    if [[ -z "$_FORGE_THEME_LOADED" ]]; then
      RPROMPT='$(_forge_prompt_info)'"''${RPROMPT:+ ''${RPROMPT}}"
    fi

    _FORGE_THEME_LOADED=$(date +%s)
  '';
}
