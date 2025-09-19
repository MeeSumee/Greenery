let
  users = {
    sumee = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHG2SPbpKOYi1kLAIOZGz4Tb2F2okroCt3J2Wq5XrMys sumee@greenery"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHITLg3/cEFB883XDG1KnaSmEAkYbqOBJMziWmfEadqO sumee@quartz"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8XrDxEKnoEvZTau4shhCKKsQlW7W3AD0xymhO1sTpF sumee@kaolin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwTjZGFn9J8wwwSAxfIirryeMBBLofBNF7fZ40engRh sumee@beryl"
    ];
  };
  
  hosts = {
    greenery = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiA3lkgGECrzk08GOhUlSIx5+jQ6WvuERK3nAz617M7"];
    quartz = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCHbUX3L2WxbS3d1EeCe+WhzdT1Tn78MzAzOz5xr1iO"];
    kaolin = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4CgVhTfEtERQsj2rIQVjLMS6vpXTBi/K2GBMHOzCUN"];
    beryl = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/j0qkT/J69KlyUNFx6sDILbCf4g20MxXBd10YDvwrd"];
  };

in {
  "secret1.age".publicKeys = users.sumee ++ hosts.greenery;
  "secret2.age".publicKeys = users.sumee ++ hosts.greenery;
  "secret3.age".publicKeys = users.sumee ++ hosts.greenery;
  "secret4.age".publicKeys = users.sumee ++ hosts.greenery;
  "secret5.age".publicKeys = users.sumee ++ hosts.kaolin;
  "secret6.age".publicKeys = users.sumee ++ hosts.greenery;
}
