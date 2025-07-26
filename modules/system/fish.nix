{
  pkgs,
  lib,
  config,
  options,
  users, 
  ...
}:
/*
                                    ____    _    _   _ ____    _    ____  _____   
                                  / ___|  / \  | \ | | __ )  / \  |  _ \| ____|  
                                  | |  _  / _ \ |  \| |  _ \ / _ \ | |_) |  _|    
                                  | |_| |/ ___ \| |\  | |_) / ___ \|  _ <| |___ _ 
                                  \____/_/   \_\_| \_|____/_/   \_\_| \_\_____( )
                                                                              |/ 
                          ____  _   _ __  __ _____ _____       ____ _   _    _    _   _ 
                          / ___|| | | |  \/  | ____| ____|     / ___| | | |  / \  | \ | |
                          \___ \| | | | |\/| |  _| |  _| _____| |   | |_| | / _ \ |  \| |
                          ___) | |_| | |  | | |___| |__|_____| |___|  _  |/ ___ \| |\  |
                          |____/ \___/|_|  |_|_____|_____|     \____|_| |_/_/   \_\_| \_|
                            
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⣠⠔⠒⠤⢄⡀⠀⠀⠀⠀⠐⠌⠓⢄⠙⢆⠐⣄⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠶⠋⠀⠀⢀⣔⠏⠐⠀⠀⠀⠀⠀⡀⠑⠢⡀⠀⠐⠘⢦⡄⠀⠀⠀⡳⡀⠀⠑⡲⡄⠘⠀⢰⡇⠠⢄⠐⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠊⠀⢀⠞⠁⠀⠀⠀⡰⠋⠁⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠐⠄⠀⠀⠀⠈⠢⡀⠀⡇⠐⢄⠀⠈⢲⣤⠀⢸⢧⠀⠀⠈⠒⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠈⠀⠠⡖⠁⠀⠀⠀⢀⠜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠈⡄⠀⠀⠀⠀⠘⢤⠁⢸⣄⠢⠀⠀⢻⡀⢸⡏⣦⣀⠀⠀⠀⠁⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡦⠂⢀⠌⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠈⠆⠀⠀⠘⡀⠀⠀⠀⠀⠸⡀⢸⡟⣢⢣⡀⠀⡏⠢⢧⣋⠡⡁⢄⠀⠀⠀⠈⠢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠊⠀⠐⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢃⠀⠀⠀⠀⡴⢻⠌⢻⣿⠊⣌⡑⢴⠀⠐⣿⡄⢻⣆⡡⡀⠂⠀⠀⠑⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⡠⠁⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⢀⡜⢀⣼⠿⠷⣝⣸⣏⡙⢬⣧⣠⡏⣇⠈⠻⡀⠱⡀⠙⡤⠀⠈⢂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠄⠌⢀⡜⠀⠀⠀⠀⠀⠌⠀⠀⠀⠀⠀⢀⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡆⠠⣊⡤⠻⠇⣖⠓⢮⣿⣽⠿⣼⢹⢇⠈⠻⢿⣄⡇⠀⢡⠀⠐⡐⢄⠀⠡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⣠⢴⢫⠁⠀⠀⠀⠀⡐⠀⠀⠀⠀⠀⠀⢞⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⢃⠄⠀⠫⣦⣄⡈⣉⡍⢏⢹⡯⣱⠏⠈⡷⣄⠈⣿⢷⡀⠈⡄⠀⠘⣄⠡⡀⠡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠗⡡⢁⡎⠠⠀⠀⠀⢠⠀⠀⠀⠀⠀⢀⠎⡌⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⢸⠐⡀⠀⠀⠑⢌⡿⡀⠘⢾⡇⢱⢀⠂⢠⢹⡆⠘⢮⣳⡀⢡⠀⠀⠰⠑⡐⠄⠡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠔⠒⠢⢄⠀⠀⡎⠠⠁⡸⡠⠁⠀⠀⢠⠂⠀⠀⠀⠀⢀⠊⣜⣀⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⡇⠱⠀⠀⠀⠀⢩⠱⡄⠘⣿⢾⣏⣀⠈⡎⣎⢦⡀⠈⠷⣼⠁⠀⠀⢃⠈⢪⠄⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠁⠀⠀⠀⠀⠀⢃⠀⠦⢁⣰⡿⠁⠀⠀⢀⠆⠀⠀⡀⠄⡲⢃⡜⠁⠀⠈⡇⠀⠀⡆⠀⠀⠀⠀⠀⡆⠀⠀⢘⢳⡀⠸⡀⠡⠑⠂⠤⣾⠋⣙⣷⡌⡟⣤⡈⢣⢸⡇⠀⣿⣦⣀⠀⢣⠀⠀⠘⡀⠀⠱⡆⢂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⢠⢎⣠⣶⣿⡟⠁⠠⠀⣠⠊⠀⠀⠁⣠⠞⡡⠊⠀⠀⠀⠀⠸⡀⠀⣳⠀⠀⠀⠀⠀⡇⠀⠀⡼⠀⠡⡀⠻⣆⠃⠀⠐⣧⠀⣿⡿⣧⣐⡿⣷⠈⡆⢧⠀⢻⣿⣝⣓⡦⣣⡀⠀⢃⠀⠀⠘⣎⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⠀⠋⠁⠀⠀⡿⠀⡰⢁⠔⠁⠀⢀⣠⠾⢁⠔⣁⢦⡀⠀⠤⢄⠀⢡⠀⢸⠃⠀⠀⠀⠀⢁⠀⢠⠃⢀⠤⠌⢢⣕⣝⢦⡀⡹⡄⠸⣿⣾⣿⢿⣿⡆⡇⠘⡷⡀⠻⣿⣿⣷⡀⠑⠀⢸⠀⠀⠀⡘⢞⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠰⣤⣀⣀⣠⣤⡶⠋⠀⢀⠄⠀⠀⠀⠀⠀⠀⠀⠀⡴⠁⡠⠖⠁⣀⠤⢒⢿⡫⠔⢻⣶⣿⣿⣿⣿⣷⣦⣄⠀⠳⠈⣎⢂⠀⠀⠀⢸⢠⠃⢈⣴⣾⣿⣿⣿⣿⣷⣞⡇⡟⢆⠙⣿⣾⣏⣿⡇⡇⡆⢳⠈⠢⣌⡻⣿⣷⡄⠀⠘⠀⡀⠀⢡⠈⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠈⠙⢿⡿⣯⣔⠂⠄⠀⠀⠀⠀⠀⠠⠢⠤⣤⣾⠷⢿⠖⠊⠉⠒⠈⠁⢸⡈⣺⣿⣿⣿⢛⣿⣿⣛⣻⡟⢇⠀⠑⣽⣎⠢⠀⠀⠐⡇⢠⢟⣿⡟⣹⣿⣉⣻⣿⣿⢠⣿⠈⠻⣎⠻⣿⣿⡇⣱⢃⠘⣇⠀⠈⢿⣶⢽⡻⣦⠀⡇⢠⠀⠀⢇⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠓⠮⢝⣃⣀⣀⣀⣀⣠⣴⠶⠛⡝⠁⢀⢧⠀⠰⡀⠀⠀⠀⠈⣷⣿⡏⢾⢿⢟⠃⠘⢻⣟⡗⠀⠀⠀⠈⠳⢧⡑⠀⠀⢡⠀⠸⣿⣟⡋⠀⢛⣿⢿⣦⣿⡇⠀⠀⠈⠣⣌⠻⣧⣸⣼⠀⣿⣆⠀⣻⠈⠓⠬⣀⡑⢧⠀⠄⠀⠸⠀⠘⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠋⠉⠉⢀⡴⠁⠀⣸⢺⠀⠀⢣⠀⠀⠀⠀⣿⠙⣧⠘⡜⠌⠢⠔⠘⣻⠃⠀⠀⠀⠀⠀⠈⠓⢤⡀⠘⡄⠀⢏⠋⠱⠀⠈⢟⡾⢫⢟⠇⠀⠀⠰⡀⠙⠦⣝⢿⣿⠀⢹⠟⣄⡏⠀⠀⠀⠙⠳⡈⠢⡀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠠⠐⢈⡞⠀⠀⢀⢻⢸⠀⠀⠈⢧⡀⠀⠀⢙⢆⠀⠕⠌⢢⣄⠀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠣⢰⡀⠈⠂⠄⣀⡠⠪⠔⠅⡸⠀⠀⢠⠳⠁⠀⠀⡏⠓⡟⡇⠀⣸⣌⡻⣖⣤⢀⡀⠀⡇⠑⠻⣆⠀⠀⠀⠀⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⡀⠤⠐⠂⠉⠀⠀⠀⡎⢠⡀⠀⡘⠈⡄⡟⡀⠀⠀⢳⡀⠀⠈⠎⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⢀⡴⠃⠀⠀⢰⠋⠀⡇⢱⠀⠏⡆⠈⠁⠀⠀⠈⠁⠓⠠⠄⡀⠀⠀⠀⠀⠈⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠙⠒⠶⠤⠤⠥⠤⢼⠀⢸⢐⠀⡷⣮⣇⢱⢡⠀⠀⠀⠹⣆⠀⠘⠌⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠁⠠⣴⡟⠁⠀⠀⠀⡼⠀⠀⡿⠶⡆⠀⡧⠤⠤⠠⠤⠤⢤⠤⠖⠚⠁⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⢸⠈⢸⠀⡇⣻⡈⡆⠡⡀⠀⠀⠘⠗⡦⣈⠀⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⡶⠮⠭⠙⢶⡆⠀⠀⠀⠠⠄⠤⣔⠊⠡⢤⠖⠉⡏⠀⠀⡐⠀⢠⠃⠠⠀⡇⠀⡇⢰⠃⠀⠀⡄⠀⢰⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠈⣼⠀⢠⢇⢷⠰⡀⠑⡄⠀⠀⠈⠻⣀⣵⡦⡬⠶⠤⠀⠀⠀⠀⠀⠀⠙⠂⠤⠐⠋⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠚⠠⡸⠀⠀⡰⠁⠀⡞⠀⢀⢷⠀⢀⢁⠆⠀⠀⠀⠃⠀⡌⣮⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠣⡀⣿⡀⠘⡸⡈⢧⡱⠀⠈⢂⠀⠀⠀⠹⡟⠛⠀⠑⠠⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⡚⠁⠀⢸⢠⠃⠀⡰⠁⠀⡼⠀⠄⡌⡌⢀⣦⠃⠀⠀⠀⢸⠀⢰⠁⢿⠀⠀⠀⠀⡆⠀⠀⠀⠀⠰⠀⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢼⣇⠀⢡⢳⠈⢷⡀⠀⠀⠁⠀⠀⠀⠱⣣⣒⠮⢖⣿⡏⢳⠢⢤⣀⡀⠀⠀⠀⠀⣀⣤⠴⢶⠟⣹⠫⡹⣄⠰⡘⡌⢀⡔⠁⢀⣼⢃⠎⡸⢰⠃⢁⠎⡘⠀⠀⠀⡆⠀⡆⢸⠐⡀⠀⠀⢸⠀⠀⠀⠀⠀⡄⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢆⠀⢎⢧⠈⠻⣦⡀⠀⠀⠈⠢⠀⠱⡀⠉⠉⠀⠈⡾⣟⣷⣮⣟⠻⡒⡻⠛⣻⣟⣻⡶⡜⠀⠉⠉⠀⠉⡛⢠⠞⠀⢠⡾⡡⠊⡰⢁⠃⠀⡜⢠⠁⠀⠀⠀⠃⢰⠁⡄⠀⠆⠀⠀⡟⠀⠀⠀⠀⠀⠃⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣡⣼⡌⠟⢄⠈⠻⣦⣀⠀⠀⠁⠂⡘⢄⠀⠀⠀⣇⣿⣿⣿⣿⣧⣼⣥⣾⣿⣿⣿⡟⡇⠀⠀⠀⠀⡜⡡⠃⠀⠀⡷⠋⠁⡔⢡⠛⠲⡜⠀⡎⠀⠀⠀⢸⠀⡌⢀⠇⠀⡇⠀⣼⠃⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡾⠛⠁⠘⢆⠈⠳⣄⠈⠫⣑⣤⡀⠀⠀⠂⠳⢤⣼⣿⣯⣿⣿⣿⢿⣿⣽⣿⣿⣯⣿⣽⣿⢦⣤⣤⠞⠀⠀⢀⠴⠋⠒⢤⡜⡰⠃⠀⢰⠁⢰⠃⠀⠀⠀⠈⢀⠃⢸⠀⠀⡇⠘⡟⡐⠀⠀⠀⢠⢣⠁⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡾⠛⠁⠀⠀⠀⠀⠈⢳⣁⠬⠷⣄⣈⡿⣿⣷⣶⣤⣄⣀⣉⣛⣿⣿⣿⣿⣽⣿⣿⣿⣿⣿⣿⣿⣛⣿⠟⠁⢀⣠⡶⢃⠠⠐⠊⠀⠈⠑⡄⠀⡇⠐⡿⠀⠀⠀⠀⠀⡸⠀⡆⠀⠀⡇⢸⠣⠁⠀⠀⠠⠂⠻⠀⢀⠃⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡶⠟⠉⠀⠀⠀⠀⠀⢀⠔⠉⣉⣀⠠⠤⠼⢄⠷⣈⢻⣻⣿⣭⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣻⣡⣤⣶⢿⠋⣡⠆⠀⣀⠠⠤⠂⠀⠓⢼⠁⢸⡇⠀⠀⠀⠀⠀⠁⠀⣇⠀⠀⣇⠏⠄⠀⠀⠀⠀⠀⠀⠀⡘⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⠀⣀⡀⠀⠀⣠⣴⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⣀⣀⣀⡆⠈⠑⢝⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿⢻⣿⡻⣿⣿⣿⡿⠟⠁⠘⣄⠘⡦⠋⠀⢀⣀⢀⡀⠀⠸⡀⡌⡇⠀⠀⠀⠀⠀⠀⢸⠀⠙⢦⡟⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀
⠀⡀⠤⠒⠉⠀⠀⠒⠲⠭⢍⣉⠒⠢⠤⠄⣀⡀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠉⠀⠀⠀⠀⣿⢄⡀⠀⠙⢿⡟⣋⠍⣋⣿⣿⣿⡟⣷⡿⢸⣿⣿⣷⣞⣉⠤⠤⣴⣶⣿⡦⠗⠤⠎⠁⠀⠀⠀⠀⠀⠁⡇⡇⠀⠀⠀⠀⠀⠀⠸⠀⠀⣸⠁⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀
⠈⠀⠀⠀⠀⠀⠀⠀⠑⢂⠀⠉⠓⢄⡀⠀⠀⠈⠉⠉⠒⠒⢾⠀⠀⠀⠀⠀⠈⠉⠁⠉⠙⣼⣹⡖⢄⡈⢻⣴⣿⣿⣿⣿⣿⡗⢬⡐⢿⣿⣿⣿⣿⣷⣤⡐⠢⣍⡛⠧⣄⠐⠓⢄⣺⣥⠓⠀⠀⡇⡇⢁⠀⠀⠀⠀⠀⠀⡃⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⡸⠁⠀⠀⠀⠀⠀⠀
⠁⠒⠒⠠⠀⣀⠀⠀⠀⠀⠀⠀⠀⣀⡁⠐⠂⠢⠤⣀⣀⠔⡾⠀⠀⠀⠀⠀⠀⢠⡴⡆⢠⡟⡻⢳⠀⠈⢢⣻⣿⣿⣿⣿⣿⢸⡏⣿⢸⣿⣿⣿⣿⣿⣿⣿⣦⡘⡜⣄⣈⣆⠀⠀⠚⠁⠀⠀⠰⣗⡓⠼⠀⠀⠀⠀⠀⠀⡇⢠⠏⠀⠀⠀⠀⠀⠀⠀⠀⢀⠁⠀⠀⠀⠀⠀⠀⠀

*/

let
  inherit (config.networking) hostName;
  rebuildCommand = "sudo nixos-rebuild --log-format bar --no-reexec --file ~/green/default.nix -A ${hostName}";

in {

  options.greenery.system.fish.enable = lib.mkEnableOption "fish shell";

  config = lib.mkIf (config.greenery.system.fish.enable && config.greenery.system.enable) {

    # Enables users to use the shell
    users.users = lib.genAttrs (users ++ ["root"])
    (
      usershell: {
        shell = pkgs.fish;
      }
    );

    # man-cache is too annoying
    documentation.man.generateCaches = false;

    # Extensive fish shell stuff
    programs.fish = {
      enable = true;

      # Removes bash script reliance for nix startups
      useBabelfish = true;

      # Abbreviations to expand commands with simple keywords
      shellAbbrs = {

        # nix stuff
        snr = rebuildCommand;
        nsh = "nix shell nixpkgs#";
        nrn = "nix run nixpkgs#";
        nip = "env NIXPKGS_ALLOW_UNFREE=1 nix --impure";        

        # I killed VMs

        # git stuff
        gaa = "git add --all";
        ga = "git add";
        gs = "git status";
        gc = "git commit";
        gcm = "git commit -m";
        gck = "git checkout -b";
        gp = "git push";
        gca = "git commit --amend";
        gcp = "git cherry-pick";
        grsa = "git restore --staged .";
        grs = "git restore --staged";
        gr = "git restore";
        gra = "git restore .";
        gd = "git diff";
        gds = "git diff --staged";
        gl = "git log";

        # misc
        qsp = "qs -p ~/green/quickshell/";
        m = "micro";
      };

      # Aliases to execute commands directly
      shellAliases = {
        ls = "eza --icons --group-directories-first -1";
        snowball = "${rebuildCommand} boot";
        snowfall = "${rebuildCommand} switch";
        snowstorm = "${rebuildCommand} test";
        snowshed = "${rebuildCommand} dry-build";
        schizo = "ssh administrator@greenery";
      };

      # Coloring shell, referenced from Zaphkiel config
      interactiveShellInit = let
        lsColors = pkgs.runCommandLocal "lscolors" {nativeBuildInputs = [pkgs.vivid];} ''
          vivid generate rose-pine > $out
        '';
        rosepine-fzf = ["fg:#908caa" "bg:-1" "hl:#ebbcba" "fg+:#e0def4" "bg+:#26233a" "hl+:#ebbcba" "border:#403d52" "header:#31748f" "gutter:#191724" "spinner:#f6c177" "info:#9ccfd8" "pointer:#c4a7e7" "marker:#eb6f92" "prompt:#908caa"];
        fzf-options = builtins.concatStringsSep " " (builtins.map (option: "--color=" + option) rosepine-fzf);
      in ''
        set sponge_purge_only_on_exit true
        set fish_greeting
        set fish_cursor_insert line blink
        set -Ux LS_COLORS $(cat ${lsColors})
        set -Ux FZF_DEFAULT_OPTS ${fzf-options}

        function fish_user_key_bindings
          bind --mode insert alt-c 'cdi; commandline -f repaint'
          bind --mode insert alt-f 'fzf-file-widget'
        end

        # hydro (prompt) stuff
        set -g hydro_symbol_start
        set -U hydro_symbol_git_dirty "*"
        set -U fish_prompt_pwd_dir_length 0
        function fish_mode_prompt; end;
        function update_nshell_indicator --on-variable IN_NIX_SHELL
          if test -n "$IN_NIX_SHELL";
            set -g hydro_symbol_start "impure "
          else
            set -g hydro_symbol_start
          end
        end
        update_nshell_indicator

        # smoll script to get the store path given an executable name
        function store_path -a package_name
          which $package_name 2> /dev/null | path resolve | read -l package_path
          if test -n "$package_path"
            echo (path dirname $package_path | path dirname)
          end
        end
      '';
    };

    # Zoxide, faster change directory
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    # Fish integration
    programs.direnv.enableFishIntegration = true;

    # CNF
    programs.command-not-found.enable = false;

    # Fuzzy Finder keybinds
    programs.fzf.keybindings = true;

    # Fish dependancies
    environment.systemPackages = with pkgs; [
      fishPlugins.done
      fishPlugins.sponge
      fishPlugins.hydro
      eza
      fish-lsp
    ];
  };
}
