# genose-port-contrib-cocotron
some port and contrib along Christopher J. W. Lloyd, Project Cocotron

# Stay tuned on Nigthly Build -- > > Not to use, just a daily status

# ########## # ########### ########### ########### ##########
   Cocotron installer commmunity updates
   Based from Christopher J. W. Lloyd
       :: Cocotron project ::
# ########## # ########### ########### ########### ##########
   Created by Genose.org (Sebastien Ray. Cotillard)
   Date 10-oct-2016
   
# ########## # ########### ########### ########### ##########
# ## Please support genose.org, the author and his projects
# ##           Based on genose.org tools
# ########## # ########### ########### ########### ##########
# http://project2306.genose.org  // git :: project2306_ide 
# ########## # ########### ########### ########### ##########

# ########## # ########### ########### ########### ##########
# ##   Initialy Created 10-oct-2016 by Genose.org (Sebastien Ray. Cotillard)
# ########## # ########### ########### ########### ##########

   Change Log :

    - Loves "" sequence
    - Hates so much, but when it cant be, Loves "long shell sentences " when don t know alternative
    - Script Cosmetics
    - More Screen & Script Cosmetics ...
    - Lots and Lots More Screen & Script Cosmetics ...
    - Lots and Lots More GUI Friendly ...
    
    - Separated logs in 3 parts (User Screen progress, Error log, Install log)
    
    - Zip / Tar / GZ, platform dependant uniformisation / standardisation
   
    - Curl and Download Improvements (see ressources/scripts/downloadIfNeeded.sh)
    - Curl based Version checker for download updates ( Http and Ftp thru http )
    
    - Remove Deprecated :
      -- > > Google Url updates to Git
      -- > > Url updates to Git / SourceForge
      
# ########## # ########### ########### ########### ##########

   - GUI Friendly (MACOS X / Linux)
     ---- > > use of gnome-terminal / xterm / konsole / Terminal.app to follow script progress thru 2 more window with args : Error log, Install log

   - ADDED More Pipes to Log files and Install.sh Screen's Pipe == > > ${SCRIPT_TTY}
   - ADDED More Graphical Pipe and Trap Ctrl-c / Exit  and send status to ${SCRIPT_TTY}
   
# ########## # ########### ########### ########### ##########
# MacOS Contributions
# ########## # ########### ########### ########### ##########

       - Fix for Sed RE error: illegal byte sequence on Mac OS X
       -- > > Sed error when compile so fix it with printenv specific 2 commands ( export LC_CTYPE=C ; export LANG=C )
       - Fix Zip / Tar / GZ, sometime don't extract
       -- > >  so use MacOSX's "Archive Utility.app" instead
 
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
