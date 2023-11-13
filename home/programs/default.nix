{ utils, disabledFiles, ...}: {
  imports = utils.listDirPathsExcluding disabledFiles ./. ;
}
