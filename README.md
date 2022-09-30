# Media Player Controller for OoTR
This script will read certain addresses in the RAM while running Ocarina of Time in BizHawk and use the values it finds to determine the current status of the game. Certain combinations of these values will be used to decide which track number to play in the currently loaded playlist in foobar2000, though in most cases it will rely on a single address in memory that always reflects either the current sequence ID or that the music is currently fading out (usually during a scene transition).

Interactivity with foobar2000 is achieved using the beefweb plugin to allow the media player to act as a web server and listen for any incoming XMLHttpRequests.

## Features
- Changes tracks and volume in foobar2000 automatically
- Restores track position when traversing between two areas with different BGMs
- Resumes current BGM when traversing between two areas that share a BGM
- Unique BGMs for areas that normally share a BGM or have no BGM

## Limitations
- No fanfare support at this time except for in a couple very specific cases. Sorry!

## Requirements
Requires the following to be installed:

**foobar2000**  
https://www.foobar2000.org

**beefweb (for foobar2000)**  
https://github.com/hyperblast/beefweb

**vgmstream (for foobar2000)**  
https://github.com/vgmstream/vgmstream

**vgmstream** is recommended here specifically for supporting audio formats that loop. Any audio format that loops indefinitely in foobar2000 should work perfectly fine with this script.

I recommend using [LoopingAudioConverter](https://github.com/libertyernie/LoopingAudioConverter) if you wish to create your own custom BGMs. In instances where the BGM should only play once I typically leave a couple seconds of silent space at the end of the BGM and loop that.

## Installing foobar2000 plugins
1. Download each plugin's respective *.fb2k-component* file from the latest release on their respective GitHub pages (usually found in the right sidebar).
2. Open each *.fb2k-component* file using foobar2000 to install each plugin (**right-click > Open with**).
3. In foobar2000 go to **File > Preferences** in the menu.
4. In the Preferences window go to **Playback > Decoding > vgmstream**.
5. Ensure **Loop forever** is selected in the options on the right.

## Ocarina of Time Randomizer settings
When generating a seed you'll want to go into the SFX tab and disable both **Background Music** and **Fanfares** as this script does not do this for you in most cases.

## Running the script
1. Save both the *zootr-bgm.lua* file and the *zootr-bgm* folder to the same location on your PC. The *Lua* folder in your BizHawk installation is an easy location to remember and the first place the Lua Console window will look when attempting to open a script.
2. Open **foobar2000** and ensure your playlist is loaded in the player. Otherwise, open the .fpl file associated with your preferred playlist.
3. Open **BizHawk**.
4. Begin running Ocarina of Time Randomizer in BizHawk.
5. Go to **Tools > Lua Console** in the BizHawk menu.
6. Open *zootr-bgm.lua* in the Lua Console.
7. If the **Media Player Controller for OoTR** window hasn't already appeared double-click **zootr-bgm** in the Lua Console.

## Creating/editing playlist settings in the script window
1. Click on the **Browse** button.
2. In the Open window select and open the .txt file you wish write to. If you want to start completely from scratch create a new .txt file and type `VOLUME=0` into it, then save it.
3. Click on any of the buttons at the bottom of the **Media Player Controller for OoTR** window to open a window with a list of tracks that match the button category.
4. In each window specify the track number you wish to use from your foobar2000 playlist for each respective track. Click on the **Save** button when finished in each respective window.
5. When finished with the playlist click on the **Save settings to this file** button in the main window to write to your .txt file.
6. If the volume of your tracks is too loud increase the value in the Volume dB Reduction field to lower the maximum volume of the media player.

## Importing playlist settings in the script window
1. Click on the **Browse** button.
2. In the Open window select and open the settings .txt file generated when the playlist was created using the script window.
3. If the playlist import was successful click on the **Apply Changes and Play Music** button.

## Caveats
- Open foobar2000 **before** running the script in BizHawk. Otherwise, the script will attempt to interact with foobar2000 right after opening and may end up causing the emulator to stutter drastically until foobar2000 is opened or the Lua Console is closed.
- The script will use the playlist identified by beefweb as *p1*. If foobar2000 isn't switching tracks try closing every playlist you currently have open (these are usually visible as tabs), close foobar2000 completely, then open it again. The first playlist should now be using the internal ID the script is looking for. If you don't use foobar2000 often and want to get around this you can keep your playlists open in other tabs and copy their contents into the first playlist whenever you want to switch out tracks.
- As long as beefweb is installed the media player controller instance beefweb hosts will always be accessible from `http://localhost:8880` in your web browser while foobar2000 is open. The script needs this to control the media player, but keep this in mind if you no longer need it in the future and intend to keep using foobar2000.
- Closing one of the script windows with the **X** button will completely remove that part of the form until you close and rerun the script. Be sure to save often when making new playlists!

## Competitive
I strongly recommend against the use of this script in competitive gameplay as it reads/writes to RAM addresses in select instances. This script was created in the interest of providing comparable functionality to MSU in ALTTP in casual gameplay. Always refer to your respective competition's rules and hosts for the legality of modifications.
