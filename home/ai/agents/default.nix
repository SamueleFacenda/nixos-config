{ utils, ... }: {
  ai.agents = utils.readAllMdFiles ./.;
}
