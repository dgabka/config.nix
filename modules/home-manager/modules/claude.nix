{...}: {
  home.file = builtins.listToAttrs (
    map (file: {
      name = ".claude/commands/${file}";
      value.source = ../../../assets/claude/commands/${file};
    }) (builtins.attrNames (builtins.readDir ../../../assets/claude/commands))
  );
}
