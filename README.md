# Magic Jewelry Randomizer
A music &amp; palette randomizer Lua script for a NES / Famicom / Pegasus bootleg game by Hwang Shinwei - Magic Jewelry. Also has ♫ karaoke &amp; a music test ♫

I programmed a Lua script to randomize music and display the lyrics for all the songs in the game, including both the lyrics for Speak Softly Love and the alternate Polish lyrics for it, sung by Akcent and known as "Za nami miłość" ( https://www.youtube.com/watch?v=XdEacEsfH3o ), as an easter egg, available by entering the Konami Code on the title screen, as shown on the YouTube video demonstrating the script ( https://www.youtube.com/watch?v=2y7u1UyTMaY )

The script also picks variations of the original 8 songs that are kinda not present in the original game - those use instruments or tempos meant for other songs, by tricking the game into loading a different song's instrument set and tempo first, by loading a whole different song for a few frames, and then quickly switching over to the target song before the "instrument & tempo donor" song starts, thus preserving the chosen instrument set & tempo, even after a loop, because this game only loads a new instrument set & tempo every level change, and the loop just jumps to a different place in the song, usually the beginning.

I also made a hacky sound test. The sound test works by always setting the current piece's X position to the middle (0x02) and the Y position to the top (0x00), erasing the GUI by writing additional info to the PPU, and then rerouting the NES / Famicom gamepad input to affect the variables in the Lua script, instead of the game's code. Then the song, instrument and tempo IDs get written to the code the same way as with the randomizing portion. For the note pitch & volume display, I got this part of the code from one of the SoundDisplay.lua scripts supplied with FCEUX and copied the way they did it almost verbatim, only changing the way it's visually displayed to fit the game's style better - my goal was to make this look like a mod for the game, instead of "just a boring emulator script"

For the fancy NES font, I used SpiderDave's ( https://github.com/SpiderDave ) helper library he wrote, that I found on a Super Mario Bros. ROMHacking Discord - SMB Arena. It contained the full font, and helper functions to draw text using the fancy font. I just plugged it into the script instead of using the standard print functions from FCEUX, that use "obvious emulator font" text boxes that don't fit the style of the game, to help me fit in the text in the game's style a little bit more.

The source code for this is freely available and released as free software... it's a piece of code I cared enough for to give it (almost) full comments, because I wanted to use the code from this script to teach my trans ex-boyfriend some coding, get him hooked on retro hardware & I'm also sharing this here, so I wanted the code to be pretty easy to understand and modify.

Also: trans rights are human rights 🏳‍⚧

Magic Jewelry is © 1990 RCM & Hwang Shinwei.
