# Secrets with agenix

secrets:
- github-token: just the plain ghp_... token
- network-keys: env var substituted in network config (see modules/network.nix), an ENV_VAR=value per line
- nix-access-tokens: used in nix.conf, contains a `access-tokens = github.com=ghp_...` and other tokens
- spotify: just the plain spotify password, see home/programs/spotify.nix
- wakatime-key: just the plain wakatime api key
