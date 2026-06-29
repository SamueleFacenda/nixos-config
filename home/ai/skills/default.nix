{ utils, ... }: {
  ai.skills = utils.readAllMdFiles ./.;
}
