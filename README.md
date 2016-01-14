# Mojo

Mojo's the first real emoji search engine for the Mac. The app is available on the [Mac App Store](https://itunes.apple.com/us/app/mojo-emoji-search/id1062448689?mt=12).

## How Does it Work?

Python scripts determine the relationship between emojis and keywords, thanks to data gathered [here](http://unicode.org/emoji/charts/full-emoji-list.html) and [here](https://github.com/muan/emojilib). 
Then, an app, written in Swift, lets you search for emojis from your menu bar and copy them to your clipboard with a single click.

Over time, Mojo learns which emojis you use the most, and moves them to the top of the list, so you can find them quicker.

Mojo depends on [this](https://github.com/thii/SwiftHEXColors/tree/master) and [this](https://github.com/shergin/NSPopover-MISSINGBackgroundView).
