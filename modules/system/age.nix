{
  inputs,
  users,
  pkgs,
  ...
}: {
  # Import agenix
  imports = [inputs.agenix.nixosModules.default];
  
  # Add agenix package for creating age files
  environment.systemPackages = [
    (inputs.agenix.packages.${pkgs.system}.default)
  ];
  
  # Identity Paths to decrypt age files
  age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"] ++ builtins.map (username: "/home/${username}/.ssh/id_ed25519") users;
}
