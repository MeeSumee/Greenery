let
  users = {
    sumee = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHG2SPbpKOYi1kLAIOZGz4Tb2F2okroCt3J2Wq5XrMys sumee@greenery"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHITLg3/cEFB883XDG1KnaSmEAkYbqOBJMziWmfEadqO sumee@quartz"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDui74G6stbKJoPcTyWe8NAexbk2TuxghA2zdf7Owma sumee@kaolin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwTjZGFn9J8wwwSAxfIirryeMBBLofBNF7fZ40engRh sumee@beryl"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3prIWylLFPpuCoNCdKNj3nCqik1lN51CZ73HXhxjvq sumee@verdure"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmulMynbxFomEUcObvRBp3bVd7kH+dO/6s/0kSBPbbg sumee@graphite"
    ];
  };
  
  hosts = {
    greenery = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiA3lkgGECrzk08GOhUlSIx5+jQ6WvuERK3nAz617M7"];
    quartz = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCHbUX3L2WxbS3d1EeCe+WhzdT1Tn78MzAzOz5xr1iO"];
    kaolin = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBLVW9nABsXKAakbIgzJdRWImREgUyxJ/8yOKpzbE9S"];
    beryl = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/j0qkT/J69KlyUNFx6sDILbCf4g20MxXBd10YDvwrd"];
  };

in {
  "secret1.age".publicKeys = hosts.greenery;
  "secret2.age".publicKeys = hosts.greenery;
  "secret3.age".publicKeys = hosts.greenery;
  "secret4.age".publicKeys = hosts.greenery;
  "secret5.age".publicKeys = hosts.kaolin;
  "secret6.age".publicKeys = users.sumee;
  "secret7.age".publicKeys = hosts.greenery;
}
