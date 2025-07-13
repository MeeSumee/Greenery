{ config, lib, pkgs, users, ...}:
{
  # Enable gnome display manager
  services.displayManager.gdm = {
  	enable = true;
  	wayland = true;
  };

  # Edit GDM dconf profile
  programs.dconf.profiles = {
  	gdm.databases = [{
  	  settings = {
  	    "org/gnome/desktop/interface" = {
  	      gtk-theme = "Nordic";
  	      cursor-theme = "xcursor-genshin-nahida";
  	      color-scheme = "prefer-dark";
  	      clock-show-weekday = true;
  	      scaling-factor = lib.gvariant.mkUint32 2;
  	    };

  	    "org/gnome/desktop/peripherals/keyboard" = {
  	      numlock-state = true;
  	    };

  	    "org/gnome/settings-daemon/plugins/color" = {
  	      night-light-enabled = true;
  	      night-light-temperature = lib.gvariant.mkUint32 3000;
  	      night-light-schedule-automatic = false;
  	      night-light-schedule-from = 8.0;
  	      night-light-schedule-to = 7.99;
  	    };
  	  };
  	}];
  };

  # Set face icon for all users
  systemd.tmpfiles.rules = lib.pipe users [
    (builtins.filter (user: config.hjem.users.${user}.files.".face.icon".source != null))
    (builtins.map (user: [
      "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
      "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${config.hjem.users.${user}.files.".face.icon".source}"
    ]))
    (lib.flatten)
  ];
/*
  Implementation of GDM background and settings
  Thanks https://github.com/cafetestrest/nixos
  Source code: https://gitlab.gnome.org/GNOME/gnome-shell/-/blob/48.2/data/theme/gnome-shell-sass/widgets/_login-lock.scss
  UPDATED TO 48.2 (Nix 25.05 Unstable)
*/
  nixpkgs = {
    overlays = [
      (self: super: {
        gnome-shell = super.gnome-shell.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            (let
              bg = pkgs.fetchurl {
                name = "vivilock.jpg";
                url = "https://cdn.donmai.us/original/6e/cc/6eccec040e4b72d5568848b26a73cd23.jpg?download=1";
                sha256 = "sha256-ADnJVg+JnAV7vIRZ3leJeF5mb2cJWEdaBPGcQZzSQtk=";
              };            
            in pkgs.writeText "bg.patch" ''
			  --- a/data/theme/gnome-shell-sass/widgets/_login-lock.scss
			  +++ b/data/theme/gnome-shell-sass/widgets/_login-lock.scss
			  @@ -1,5 +1,5 @@
			  -$_gdm_bg: $system_base_color;
			  -$_gdm_fg: $system_fg_color;
			  +$_gdm_bg: transparent;
			  +$_gdm_fg: black;
			   $_gdm_dialog_width: 25em;
			   
			   // common style for login and lockscreen
			  @@ -165,11 +165,11 @@
			       .login-dialog-user-list-item {
			         // use button styling
			         @extend %button_common;
			  -      @include button(normal, $tc:$_gdm_fg, $c:$system_base_color, $always_dark: true);
			  +      @include button(normal, $tc:$_gdm_fg, $c:$_gdm_bg, $always_dark: true);
			         &:selected,
			  -      &:focus { @include button(focus, $tc:$_gdm_fg, $c:$system_base_color, $always_dark: true);}
			  -      &:hover { @include button(hover, $tc:$_gdm_fg, $c:$system_base_color, $always_dark: true);}
			  -      &:active { @include button(active, $tc:$_gdm_fg, $c:$system_base_color, $always_dark: true);}
			  +      &:focus { @include button(focus, $tc:$_gdm_fg, $c:$_gdm_bg, $always_dark: true);}
			  +      &:hover { @include button(hover, $tc:$_gdm_fg, $c:$_gdm_bg, $always_dark: true);}
			  +      &:active { @include button(active, $tc:$_gdm_fg, $c:$_gdm_bg, $always_dark: true);}
			   
			         border-radius: $modal_radius;
			         padding: $base_padding * 1.5;
			  @@ -219,7 +219,10 @@
			   }
			   
			   #lockDialogGroup {
			  -  background-color: $_gdm_bg;
			  +  background: url('file://${bg}');
			  +  background-repeat: no-repeat;
			  +  background-size: cover;
			  +  background-position: center;
			   }
			   
			   // Clock
			  
           '')
          ];
        });
      })
    ];
  };
}
