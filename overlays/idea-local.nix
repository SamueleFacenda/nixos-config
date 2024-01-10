final: prev: {
  jetbrains = prev.jetbrains // {
    idea-ultimate = prev.jetbrains.idea-ultimate.overrideAttrs {
      # preferLocalBuild = true;
    };
  };
}
