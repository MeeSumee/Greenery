{
  sources,
  users,
  pkgs,
  ...
}: {
  # Import agenix
  imports = [(sources.agenix + "/modules/age.nix")];
  
  # Add agenix package for creating age files
  environment.systemPackages = [
    (pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" {})
  ];
  
  # Identity Paths to decrypt age files
  age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"] ++ builtins.map (username: "/home/${username}/.ssh/id_ed25519") users;
}
