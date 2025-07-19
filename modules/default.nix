{
  lib,
  options,
  ...
}:{
  imports = [
    ./desktop
    ./hardware
    ./networking    
    ./programs
    ./server
    ./system
  ];
  
  # Do you really want to disable every single file in modules lmfao??
  options.greenery.enable = lib.mkEnableOption "すべて";
}