{ utils, ... }: {
  ai.commands = utils.readAllMdFiles ./.;
}
