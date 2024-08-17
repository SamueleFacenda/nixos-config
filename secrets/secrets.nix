let
  surface-samu = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDmwY1YTLStEcSB7srpkw6imrFMsVoT/shdu+qNG48T1aqEbnVlvKnDwNO757NyGxI1uXl8K/U/eZofdIT4ZkLc9FQJYcmBh5cd8sLnvDsxsD9lVvIaABje9YKT0T9/f5WJhuyvc0dds0NgwUqw+P0Ik0bhsLrBttn4brIekQU1gv7S0hG0WXgBKlfLoap4hH9NYXTaCfoISx3PoJICozc2U6Fw48aH5Yh7xMCvhwjfZUhi/Gdbi5eJMyygjr5VIXfAhHtmuBbGN5WmY7bjQ5UqVqWBGLFZSYGTpfQljupjnUgQNEurW1T5MvLk+xqq6Jr8LeMYcVNioGar5+kJqcYB3Ya8XD8Dn7SdlpWp5Sqoap1AizjhD+tDdzrzCOGjhd2ApEDYldRzL40qHjWH4GA9knrWPceeZdKozFEA9dEP1TRgRP4pPKjk9lrtlSW2tgijuOKLTi8O7bNgvOm62R7m4jfB58Fw4jtJx6ZPceKfSPeSDhrovoXd7GZKOI8LmY8="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE59Df0Xe2lYi3XVqT7XLhR6/KneHvIt8uzi1zAXzMJs"
  ];

  zenbook = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFL+UNaFO1NkvU+lvlaIbIDSLiXmRIgT2/C3r6rt2O+"
  ];
  
  surface-ng = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcBmbjND6MiySUj0aP02nhuBUZerTTdJxO+bqFq5GTg"
  ];

  systems = surface-samu ++ zenbook ++ surface-ng;
in
{
  "github-token.age".publicKeys = systems;
  "wakatime-key.age".publicKeys = systems;
  "network-keys.age".publicKeys = systems;
  "spotify.age".publicKeys = systems;
  "nix-access-tokens.age".publicKeys = systems;
}
