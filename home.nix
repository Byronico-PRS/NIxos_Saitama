{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "paulos";
  home.homeDirectory = "/home/paulos";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  #Programas
  programs.home-manager.enable = true;

     home.packages = with pkgs; [ 
       #games
       scid #chessdatabase
       ltris #tetris
       abuse #sidescroller action game
       xonotic
       stockfish     
       #escritório
       unetbootin
       nextcloud-client
       weylus
       screenkey
       #imagens
       gimp
       inkscape 
        #audio
       reaper #daw
       vmpk    #piano
       musescore #editor de partitura
       carla     #plugin manager
       guitarix # guitar amps
       gxplugins-lv2 #guitar plugin
       calf #plugin suite
       helm #synth
       distrho #plugin suite
       drumgizmo #bateria
              
                
  ];


}
