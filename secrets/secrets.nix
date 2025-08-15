let
  users = {
    administrator = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHG2SPbpKOYi1kLAIOZGz4Tb2F2okroCt3J2Wq5XrMys"];
    sumeezome = [""];
    sumee = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHITLg3/cEFB883XDG1KnaSmEAkYbqOBJMziWmfEadqO sumee@quartz"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8XrDxEKnoEvZTau4shhCKKsQlW7W3AD0xymhO1sTpF sumee@kaolin" 
    ];
  };
  
  hosts = {
    greenery = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiA3lkgGECrzk08GOhUlSIx5+jQ6WvuERK3nAz617M7"];
    quartz = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCHbUX3L2WxbS3d1EeCe+WhzdT1Tn78MzAzOz5xr1iO"];
    kaolin = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4CgVhTfEtERQsj2rIQVjLMS6vpXTBi/K2GBMHOzCUN"];
  };

in {
  "secret1.age".publicKeys = users.administrator ++ hosts.greenery;
  "secret2.age".publicKeys = users.administrator ++ hosts.greenery;
}
