#!/bin/bash
echo "
___________________________

         /\\      /\\
        //\\\    /||\\
       //--\\\    ||
      //    \\\   ||
___________________________

"

echo "Running 'sudo pacman -Syyu' ..."
sudo pacman -Syyu
read -p "Press Enter to exit..."
