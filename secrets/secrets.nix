let
  sumee = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHG2SPbpKOYi1kLAIOZGz4Tb2F2okroCt3J2Wq5XrMys sumee@greenery"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHITLg3/cEFB883XDG1KnaSmEAkYbqOBJMziWmfEadqO sumee@quartz"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDui74G6stbKJoPcTyWe8NAexbk2TuxghA2zdf7Owma sumee@kaolin"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwTjZGFn9J8wwwSAxfIirryeMBBLofBNF7fZ40engRh sumee@beryl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3prIWylLFPpuCoNCdKNj3nCqik1lN51CZ73HXhxjvq sumee@verdure"
  ];

  nahida = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiA3lkgGECrzk08GOhUlSIx5+jQ6WvuERK3nAz617M7"];
  leaf = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdCRc7/VwBWConOyhV/3R9CiFK9RCaA04tGGuM+cOso"];
  soft = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBLVW9nABsXKAakbIgzJdRWImREgUyxJ/8yOKpzbE9S"];

  cute = nahida ++ leaf;
  # Principle of least privilege, other than Nahida <3
in {
  "secret1.age".publicKeys = cute;
  "secret2.age".publicKeys = nahida;
  "secret3.age".publicKeys = cute;
  "secret4.age".publicKeys = cute;
  "secret5.age".publicKeys = soft ++ nahida;
  "secret6.age".publicKeys = sumee ++ nahida;
}
