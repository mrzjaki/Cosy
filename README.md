Cosy Dotfiles
=============
A collection of configurations to set up a familiar and consistent environment. 

Usage
---

- Install homesick to setup and manage dotfiles

```
	$ gem install --no-ri --no-rdoc homesick 
	$ homesick clone mrzjaki/cosy
	$ homesick symlink mrzjaki/cosy
```

- Run `init_osx.sh` to provision OSX with favourite tools, native applications and OSX settings. This will take a while and would require your occasionally input.

```
	$ sh init_osx.sh
```

Bootstrap System(s)
---
OSX is **not** being used as a development environment. Instead, I prefer a virtualized development environment using the voodoo of vagrant and virtualbox. The virtualized development environment uses Ubuntu, for now.

This way, I keep my OSX as pristine as possible.

### OSX (Mountain Lion)
#### Notes: 
Script will not run if Xcode Command Line Tools is not installed, I hope.

##### Homebrew
	
- brew-cask
- bash
- bash-completion
- git
- hub
- trash
- tree
- webkit2png
- wget

##### Homebrew-Cask

- adium
- bettertouchtool
- cyberduck
- dropbox
- github
- google-chrome
- google-chrome-canary
- iterm2
- sublime-text
- the-unarchiver
- transmission
- vagrant
- virtualbox
- vlc 


##### Bash Version 4.2 (via homebrew)
Highly optional, only because I have no idea what's the difference. OSX 10.8 comes with bash version 3.x and works just fine for me. But I want a consistent bash version to work with, and the easiest way is to use the latest and greatest. 

##### Sane OSX Defaults
Highly optional, because different people prefer different cups of tea. As much as possible, I'd like to automate the whole process of setting up my new machine(s). 
