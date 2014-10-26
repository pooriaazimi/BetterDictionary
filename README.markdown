BetterDictionary
================
BetterDictionary is a plugin for Apple's Dictionarry.app that allows you to bookmark words.

It works on Yosemite, Mavericks, Mountain Lion, Lion, and Snow Leopard.

![Screenshot1](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/BetterDictionary-Yosemite.png)



Download and Installation
-------------------------

### OS X 10.10 (Yosemite) and 10.9 (Mavericks)


1. Download the latest version of [EasySIMBL](https://github.com/norio-nomura/EasySIMBL). Currently it is [version 1.6](http://github.com/norio-nomura/EasySIMBL/releases/download/EasySIMBL-1.6/EasySIMBL-1.6.zip)

2. Extract `EasySIMBL-1.6.zip` and move `EasySIMBL.app` into the Applications folder.

3. Run EasySIMBL

4. Download and extract [BetterDictionary-v0.991.zip](https://github.com/pooriaazimi/BetterDictionary/releases/download/v0.991/BetterDictionary-v0.991.zip). It contains two files: `BetterDictionary.bundle` and `migrate-data`.

5. Make sure "Use SIMBL" is checked.

6. Drag and drop `BetterDictionary.bundle` into EasySIMBL:

	![Screenshot1](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/EasySIMBL.png)


##### To migrate your data (from Mountain Lion)

1. If you were already using BetterDictionary under Mountain Lion (or older versions) and wish to migrate your data, right-click on `migrate-data` and select 'Open'. In the next dialog, select 'Open' again.

2. Dictionary.app should open now, with all your previous saved words intact. If it didn't work, simply copy `~/Library/Application Support/BetterDictionary/saved-words.plist` to `~/Library/Containers/com.apple.Dictionary/Data/Library/Application Support/BetterDictionary/saved-words.plist`.


### OS X 10.8 (Mountain Lion), 10.7 (Lion), and 10.6 (Snow Leopard)

Download [v0.98](https://github.com/downloads/pooriaazimi/BetterDictionary/BetterDictionary-0.98.zip) from the [Downloads](https://github.com/pooriaazimi/BetterDictionary/downloads) section. Then double-click on `BetterDictionary-0.98.zip` to unzip it.

Right click on `BetterDictionary-0.98.app` and select 'Open'. In the next dialog, select 'Open' again. Then install the SIMBL plugin loader as instructed in the installer.



Uninstall
---------

### Removing BetterDictionary

- **OS X 10.10 and 10.9**

  Simply disable BetterDictionary in EasySIMBL.

- **OS X 10.8, 10.7, and 10.6**

  Open Terminal.app (from Applications -> Utilities). Type `open /Library/Application\ Support/SIMBL/Plugins/` and press return.

  Then Remove 'BetterDictionary.bundle' from this directory.

### Removing SIMBL

Just download, unzip and run [SIMBL Uninstaller](https://raw.github.com/pooriaazimi/BetterDictionary/master/Installers/SIMBL%20Uninstaller.zip) (86 KB). It will remove SIMBL and all its plugins from your system.





Keyboard Shortcuts
------------------
**⌘+S**: Save word

**⌘+R**: Remove word

**⌘+⇧+D**: Display sidebar




Version History
---------------

### [v0.991](https://github.com/pooriaazimi/BetterDictionary/releases/tag/v0.991) (October 26th, 2014)

- Updated for OS X 10.10 Yosemite

- Automatically display the drawer when Dictionary.app is opened

- Remove the occasionally-troublesome "⌘+⇧+R" shortcut



### [v0.99](https://github.com/pooriaazimi/BetterDictionary/releases/tag/v0.99) (November 15th, 2013)

- Updated for OS X 10.9 Mavericks

- On Mavericks, BetterDictionary now uses a drawer to display the sidebar

- Dictionary.app is sandboxed under 10.9, so the saved word database is now at `~/Library/Containers/com.apple.Dictionary/Data/Library/Application Support/BetterDictionarysaved-words.plist`

- v0.99 uses a simple [ruby script](https://github.com/pooriaazimi/BetterDictionary/blob/e94e6a0faa0ca228255db88bd55ab69ab8dbccad/Installers/BetterDictionary-0.99/migrate-data) to move saved words database from its previous location to sandbox container



### [v0.98](https://github.com/pooriaazimi/BetterDictionary/releases/tag/v0.98) (October 10th, 2012)

- Now works on Mountain Lion

- Saved words database is now at `~/Library/Application Support/BetterDictionary/saved-words.plist`

- Fixed a few bugs



### [v0.97](https://github.com/pooriaazimi/BetterDictionary/releases/tag/v0.97) (July 28th, 2012)

- Newer words are now shown on top



### [v0.96](https://github.com/pooriaazimi/BetterDictionary/releases/tag/v0.96) (March 4th, 2012)

- Lion compatibility



### [v0.95](https://github.com/pooriaazimi/BetterDictionary/releases/tag/v0.95) (September 22nd, 2011)

- Initial release



Screenshots
-----------
### Yosemite

![Screenshot1](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/BetterDictionary-Yosemite.png)


### Mavericks

![Screenshot1](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/BetterDictionary-Mavericks.png)


### Mountain Lion

![Screenshot1](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/BetterDictionary-MountainLion.png)


### Lion

![Screenshot1](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/BetterDictionary-Lion.png)


### Snow Leopard

![Screenshot2](https://github.com/pooriaazimi/BetterDictionary/raw/master/Images/BetterDictionary-SnowLeopard.png)
