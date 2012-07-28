BetterDictionary
================
BetterDictionary is a plugin for Apple's Dictionarry.app, that lets you bookmark searched words.

It works on Mountain Lion, Lion and Snow Leopard. 


Download
--------
You can always download the latest version from [Downloads](https://github.com/pooriaazimi/BetterDictionary/downloads) tab. Currently it's [v0.97](https://github.com/downloads/pooriaazimi/BetterDictionary/BetterDictionary-0.97.pkg).

  - sha1sum: `4ce7b3ec621d0cab7b78f3b0ed6de1c39e3af821`
  
  - size: 611 KB


Installation
------------

Due to new security features in Mountain Lion, it's significantly harder to install v0.97. Installing [v0.96](https://github.com/downloads/pooriaazimi/BetterDictionary/BetterDictionary-0.96.pkg) was just as easy as running the installer, but for installing v0.97, you must now follow these steps:

- **Moutain Lion:**

  - If you don't have SIMBL installed, first [download](http://www.culater.net/dl/files/SIMBL-0.9.9.zip) it.
  
  - Unzip "SIMBL-0.9.9.zip", right click on the installer ("SIMBL-0.9.9.pkg") and select "Open".
  
  - Select "Open" again in the alert box. Proceed as usual. You'll be prompted to enter your password in the next screen.
  
  - Then download [BetterDictionary installer](https://github.com/downloads/pooriaazimi/BetterDictionary/BetterDictionary-0.97.pkg).
	
  - Right click on the downloaded file and select "Open".
	
  - Select "Open" again in the alert box. Proceed as usual. You'll be prompted to enter your password in the next screen.
	
- **Lion and Snow Leopard:**

  - If you don't have SIMBL installed, first [download](http://www.culater.net/dl/files/SIMBL-0.9.9.zip) and install it.
  
  - Download [BetterDictionary installer](https://github.com/downloads/pooriaazimi/BetterDictionary/BetterDictionary-0.97.pkg).
	
  - Double click on the downloaded file to install. You'll be prompted to enter your password in the next screen.

  
The installer package copies BetterDictionary.bundle to `/Library/Application Support/SIMBL/Plugins/`.



Uninstalling
------------

#### Removing BetterDictionary

Open Terminal.app (from Applications -> Utititles). Type `open /Library/Application\ Support/SIMBL/Plugins/` and press return.

Remove 'BetterDictionary.bundle' from this directory.

#### Removing SIMBL

Just download, unzip and run [SIMBL Uninstaller](https://raw.github.com/pooriaazimi/BetterDictionary/master/Installers/SIMBL%20Uninstaller.zip) (86 KB). 


Release Notes
-------------

### v0.97

- Mountain Lion compatibility

- Newer words are now shown on top

### v0.96

- Lion compatibility

### v0.95

- Initial release


Keyboard Shortcuts
------------------
**⌘+S**: Save word

**⌘+R**: Remove word

**⌘+⇧+D**: Display sidebar

**⌘+⇧+R**: Remove all saved words


Screenshots
-----------
![Screenshot1](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/BetterDictionary-MountainLion.png)

![Screenshot1](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/BetterDictionary-Lion.png)

![Screenshot2](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/BetterDictionary-SnowLeopard.png)