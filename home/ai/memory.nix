{ ... }:

{
  # Session environment variables (shared by both agents)
  home.sessionVariables = {
    # Headroom proxy
    HEADROOM_PROXY_URL = "http://localhost:8787";
    HEADROOM_OUTPUT_SHAPER = "1";

    # Token optimizer
    TOKEN_OPTIMIZER_ENABLED = "1";

    # Direnv
    DIRENV_ALLOW = "1";
  };
}
