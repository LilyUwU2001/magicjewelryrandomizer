-- Magic Jewelry Music & Palette Randomizer, v1.21
-- Randomizes music every level - Randomizes track, instrument set & tempo in the sound engine, also randomizes the palettes too.
-- Script by LilyUwU2001 (she/her), 2023. Game by (C) 1990 Hwang Shinwei. 
-- Love is love. Trans rights are human rights. Happy Pride Month.

-- CHANGELOG:
-- v1.21
-- updated creator's pronouns, year & removed any association with Polish NES/Pegasus enthusiast forums.
-- v1.2
-- added sound test so you can listen to every track at any time
-- v1.1
-- added NES font to track display, added new title screen to the game
-- v1.01
-- not forcing fast AKoE instruments for fast tempo versions of songs anymore
-- v1.0 
-- initial release

-- require font & printing functions (by SpiderDave)
require "SpiderDave_functions"
require "default_font"

-- current version
game_version = "v1.21"
lgbt_quotes = {"LOVE IS LOVE!", "TRANS RIGHTS ARE HUMAN RIGHTS.", "NO HUMAN IS ILLEGAL.", "OUT AND PROUD!", "WE'RE HERE. WE'RE QUEER.", "SOUNDS GAY, I'M IN.", "LOVE YOURSELF.", "QUEER AF.", "LOVE IS NOT A CRIME.", 
"HE,HIM. SHE,HER. THEY,THEM. US.", "GAY FRIENDLY.", "EQUALITY.", "EVERYONE IS WELCOME!", "THE FUTURE IS TRANS.", "NOT GONNA HIDE MY PRIDE.", "GAYMERS RISE UP!", "LOVE OUT LOUD!", "BORN THIS WAY!",
"PRIDE IS FOR EVERYONE.", "CELEBRATE TRANS PRIDE.", "THEY AND THEM AND EVERYONE.", "GENDER IS A SOCIAL CONSTRUCT.", "EVERYONE IS GAY AND THAT'S OKAY", "IS THIS HEAVEN,OR JUST A DREAM?"}
lgbt_size = 0 -- LGBT texts table size
lgbt_text = 0 -- chosen random LGBT text

-- calculate LGBT table length
for _ in pairs(lgbt_quotes) do lgbt_size = lgbt_size + 1 end

-- select random LGBT-related text
lgbt_text = math.random(1, lgbt_size)

-- variables
music = 0 -- current music
instruments = 0 -- current instrument set
tempo_modifier = 0 -- is tempo modifier applied?
tempo_random = 0 -- RNG for tempo modifier
tempo = 0 -- current music tempo
tempos = {7, 5, 5, 7, 7, 7, 7, 7, 7, 5, 5, 5, 6, 5, 5, 7}   -- default tempos for all songs in the game.
song_names = {"All Kinds of Everything", "Happy Chinese Festival", "Long de Chuanren", "Altered Beast Theme", "Jagerchor", "Moonlgt on the Colorado", "Greensleeves", "Speak Softly Love", "All Kinds of Everything", "Happy Chinese Festival", "Long de Chuanren", "Happy Chinese Festival", "All Kinds of Everything", "Happy Chinese Festival", "Long de Chuanren", "Rise from Your Grave"} -- all song names
variation_number = 0 -- number of current variation
-- level counting variables
level100s = 0
level10s = 0
level1s = 0
current_level = 0 -- current level in decimals
game_loop = 0 -- current game loop (level / 16)
-- lyrics info variables
lyrics_option = 1
lyrics_option_texts = {"KARAOKE MODE OFF", "KARAOKE MODE ON!"} -- lyrics options
lyrics_option_texts_short = {"-NO KARAOKE-", "-KARAOKE ON-"} -- lyrics options, short
lyrics_timeout = 0 -- time for lyrics text to appear
-- Konami Code variables
enable_alternate_ssl = 0 -- should alternate lyrics for Speak Softly Love be enabled?
konami_code = 0 -- Konami Code steps
konami_timeout = 0 -- time for Konami text to appear
-- sound test mode variables
sound_test = 0 -- is the game in sound test mode?
sq1_volume = 0 -- square 1 volume
sq2_volume = 0 -- square 2 volume
tri_volume = 0 -- triangle volume
iterator = 15
semitones = {"A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"} -- semitone list
note = "C" -- current note
octave = "4" -- current octave
semitone = "" -- current semitone
sound_sel = 0 -- selection in sound test menu
sound_timeout = 0 -- timeout for sound test change
gui_erased = 0 -- was GUI erased?
-- actual lyrics variables
lyrics_songpos = 0 -- song position
current_lyric = "" -- currently displayed lyric
-- gamepad variables
pad_thisframe = 0 -- this frame's input
pad_prevframe = 0 -- previous frame's input
-- lyrics tables
lyrics_texts = {
    "- All Kinds of Everything -", -- lyrics for All Kinds of Everything
    "Snowdrops and daffodils", "Butterflies and bees", "Sailboats and fishermen", "Things of the sea", "Wishing-wells", "Wedding bells", "Early morning dew", 
    "All kinds of everything", "remind me of you", "Summertime", "Wintertime", "Spring and autumn too", "Monday Tuesday", "every day", "I think of you",

    "- Happy Chinese Festival -",  -- no lyrics for Happy Chinese Festival!

    "- Long de Chuanren -", -- lyrics for Long de Chuanren
    "Yao yuan di dong", "fang you yi tiao jiang", "Ta di ming", "zi jiu jiao Chang Jiang", "Yao yuan di dong", "fang you yi tiao he", "Ta di ming", "zi jiu jiao Huang He",
    "Ju long jiao", "di xia wo cheng zhang", "Zhang cheng yi hou", "shi long de chuan ren", "Hei yan jing", "Hei tou fa Huang pi fu", "Yong yong yuan yuan", "shi long de chuan ren",

    "- Altered Beast Theme -",  -- no lyrics for Altered Beast Theme!

    "- Jagerchor -", -- lyrics for Jagerchor
    "Was gleicht wohl auf Erden", "dem Jaegervergnuegen", "Wem sprudelt der Becher", "des Lebens so reich?", "Beim Klange der Hoerner", "im Gruenen zu liegen", "Den Hirsch zu verfolgen",
    "durch Dickicht und Teich", "Ist fuerstliche Freude,", "ist maennlich Verlangen,", "Erstarket die Glieder", "und wuerzet das Mahl.", "Wenn Waelder und Felsen", "uns hallend umfangen",
    "Toent freier und freud ger", "der volle Pokal!", "Jo ho! Tralalalala!",

    -- lyrics for Moonlight on the River Colorado (song kicks off instantly, no time to display title!)
    "Moonlight on the river", "Colorado", "How I wish", "that I were there with you", "As I sit and find", "each lonely shadow", "Takes me back to days", "that we once knew",
    "We were to wed", "in harvest time, you said", "That's why", "I'm longing for you", "When it's", "moonlight on the Colorado", "I wonder", "if you're waiting for me too",

    "- Greensleeves -", -- lyrics for Greensleeves
    "Alas, my love, you do me wrong", "To cast me off discourteously", "And I have loved you", "oh, so long", "Delighting in your company.", "Greensleeves was my delight,", "Greensleeves my heart of gold",
    "Greensleeves my heart of joy", "And who", "but my Lady Greensleeves",

    "- Speak Softly Love -", -- lyrics for Speak Softly Love
    "Speak softly, love and hold me", "warm against your heart", "I feel your words,", "the tender trembling", "moments start.", "We're in a world,", "our very own,", "Sharing a love", "that only few", 
    "have ever known.", "Wine-colored days", "warmed by the sun,", "Deep velvet nights,", "when we are one.", "Speak softly, love so no one", "hears us, but the sky", "The vows of love", "we make will live",
    "until we die.", "My life is yours", "and all because,", "you came into my world", "with love, so softly love."
}

lyrics_timetable = {
    0xF37A, 0xF3AB, 0xF3BD, 0xF3CE, 0xF3E0, 0xF3F0, 0xF3F9, 0xF402, 0xF419, 0xF42A, 0xF442, 0xF44B, 0xF456, 0xF466, 0xF470, 0xF479,                 -- timetable for All Kinds of Everything
    0xF721,                                                                                                                                         -- timetable for Happy Chinese Festival
    0xFD3D, 0xFD52, 0xFD5C, 0xFD6C, 0xFD76, 0xFD87, 0xFD91, 0xFDA1, 0xFDAA, 0xFDBA, 0xFDC3, 0xFDD3, 0xFDDC, 0xFDEC, 0xFDF6, 0xFE06, 0xFE0F,         -- timetable for Long de Chuaren
    0xFB58,                                                                                                                                         -- timetable for Altered Beast Theme
    0x1001, 0x1005, 0x1017, 0x1029, 0x1037, 0x1045, 0x1055, 0x1069, 0x1079, 0x1083, 0x1093, 0x10A2, 0x10B0, 0x10BE, 0x10CC, 0x10DC, 0x10EA, 0x10F9, -- timetable for Jagerchor           
    0x12F7, 0x1307, 0x1319, 0x1321, 0x133A, 0x1348, 0x135C, 0x136A, 0x137D, 0x138A, 0x139E, 0x13A4, 0x13BD, 0x13C3, 0x13DF, 0x13E5,                 -- timetable for Moonlight on the Colorado  
    0x16A1, 0x16D0, 0x16F4, 0x1716, 0x172A, 0x1738, 0x175D, 0x1788, 0x17A8, 0x17D1, 0x17DB,                                                         -- timetable for Greensleeves            
    0x1B0A, 0x1B5B, 0x1B69, 0x1B77, 0x1B7F, 0x1B89, 0x1B93, 0x1B9F, 0x1BAB, 0x1BB3, 0x1BBB, 0x1BC7, 0x1BD2, 0x1BDF, 0x1BEB, 0x1BF7, 0x1C05, 0x1C13, -- timetable for Speak Softly Love
    0x1C1B, 0x1C23, 0x1C2F, 0x1C3B, 0x1C47, 0x1C53                                                                                                  -- timetable for Speak Softly Love (continued)
} 

ssl_alternate = {
    "- Za nami milosc -", -- ALTERNATE Polish lyrics for Speak Softly Love (Za nami miłość, by Akcent)
    "Za nami milosc,", "najpiekniejsza jaka jest.", "Za nami milosc,", "krajobrazy tamtych miejsc.", "Spelniony czas,", "spelnione dni,", "I struna slonca,", "ktora jeszcze w dloniach drzy.",
    "Spogladam wstecz,", "lecz coz to da?", "Gdzie dzisiaj ty?", "Gdzie dzisiaj ja?", "Za nami milosc,", "jakby rozna iskra dnia.", "Za nami milosc,", "ktora z nami ku nam szla.",
    "Gdzie dzisiaj my?", "My z tamtych lat", "Niesiemy serce dzis,", "niesiemy, w obcy swiat."
}

alt_timetable = {
    0x1B0A, 0x1B5B, 0x1B65, 0x1B77, 0x1B81, 0x1B93, 0x1B9F, 0x1BAB, 0x1BB5, 0x1BC7, 0x1BD0, 0x1BDF, 0x1BEB, 0x1BF7, 0x1C01, 0x1C13, 0x1C1D, 0x1C2F, -- timetable for Za nami miłość
    0x1C3B, 0x1C47, 0x1C53                                                                                                                          -- timetable for Za nami miłość (continued)
}

lyrics_size = 0 -- timetable size
alt_size = 0 -- alt lyrics timetable size

-- calculate lyrics table length
for _ in pairs(lyrics_timetable) do lyrics_size = lyrics_size + 1 end

-- calculate alt lyrics table length
for _ in pairs(alt_timetable) do alt_size = alt_size + 1 end

function calculate_level()
    -- calculate the current level and game loop for levels > 16 to have proper speed and challenge
    -- for some weird reason, music is hardcoded and tied to the levels?!
    level1s = memory.readbyte(0x0087)
    level10s = memory.readbyte(0x0088)
    level100s = memory.readbyte(0x0089)
    current_level = level100s*100 + level10s * 10 + level1s
    game_loop = current_level / 16
end

function process_lyrics()
    -- if alternate SSL lyrics enabled, always turn on karaoke mode
    if enable_alternate_ssl == 1 then
        lyrics_option = 2;
    end
    -- read byte $0004 to determine if game currently not on title screen
    if memory.readbyte(0x0004) ~= 0 then
        -- if karaoke mode is on...
        if lyrics_option == 2 then
            -- read song space in memory
            lyrics_songpos = memory.readbyte(0x05E4) * 256 + memory.readbyte(0x05E3)
            -- display lyrics
            drawfont(8*1-5,8*28,font[1], "@"..current_lyric.."                               ")
            -- if music is not Speak Softly Love or alternate SSL lyrics are disabled...
            if music ~= 7 or enable_alternate_ssl == 0 then
                -- check if any lyrics should change during lyrics timetable hit in current song space in memory
                for hit=1,lyrics_size,1 do
                    if lyrics_songpos == lyrics_timetable[hit] then
                        current_lyric = lyrics_texts[hit]
                    end
                end
            end
            -- if music is Speak Softly Love and alternate SSL lyrics are enabled...
            if music == 7 and enable_alternate_ssl == 1 then
                -- check if any lyrics should change during lyrics timetable hit in current song space in memory
                for hit=1,alt_size,1 do
                    if lyrics_songpos == alt_timetable[hit] then
                        current_lyric = ssl_alternate[hit]
                    end
                end
            end
            -- draw note
            draw_note(0,224);
        end
    end
end

function play_konami_sfx()
    -- play Konami Code sfx by writing data to APU registers
    memory.writebyte(0x4015, 0x15)                    
    memory.writebyte(0x4002, 0x92)  
    memory.writebyte(0x4003, 0x50)
    memory.writebyte(0x4000, 0x44)
    memory.writebyte(0x4001, 0xB0)                                               
end

function play_switch_sfx()
    -- play switch sfx by writing data to APU registers
    memory.writebyte(0x4015, 0x15)                    
    memory.writebyte(0x4002, 0xA6)  
    memory.writebyte(0x4003, 0x01)
    memory.writebyte(0x4000, 0x81)
    memory.writebyte(0x4001, 0xAC)                                               
end


function process_gamepad()
    -- process gamepad input
    pad_prevframe = pad_thisframe
    pad_thisframe = joypad.read(1)
end

function process_title()
    -- read byte $0004 to determine if game currently on title screen
    if memory.readbyte(0x0004) == 0 then
        -- print game title
        drawfont(8*8-5,8*2,font[1], "- MAGIC JEWELRY -")
        -- if game on title screen, draw copyright info
        drawfont(8*8-5,8*20,font[1], "2023 LILYUWU2001")
        drawfont(8*8-5,8*22,font[1], "&")
        drawfont(8*23-5,8*22,font[1], ".")
        draw_copy(7*8-5,8*20)
        -- draw version number
        drawfont(8*27-5,8*28,font[1], game_version)
        -- draw a random LGBT-related text
        drawfont(8*16-8*math.floor(string.len(lgbt_quotes[lgbt_text])/2)-5,8*26,font[1], lgbt_quotes[lgbt_text])
        -- if lyrics timeout > 0 display chosen lyrics option
        if lyrics_timeout > 0 then
            drawfont(8*8-5,8*22,font[1],lyrics_option_texts[lyrics_option])
            lyrics_timeout = lyrics_timeout - 1;
        end
        -- if Konami timeout > 0 display Konami Code text
        if konami_timeout > 0 then
            drawfont(8*8-5,8*22,font[1],"Alt. SSL Lyrics!")
            konami_timeout = konami_timeout - 1;
        end
        -- if player pressed select, enable or disable karaoke mode
        if pad_thisframe["select"] then
            if lyrics_timeout <= 0 then
                -- play switch sfx
                play_switch_sfx();
                -- enable karaoke mode
                lyrics_option = lyrics_option + 1
                -- if karaoke mode already enabled, disable it
                if lyrics_option > 2 then
                    lyrics_option = 1
                end
                -- enable lyrics info text
                lyrics_timeout = 60
            end
        end
        -- draw sound test state
        if sound_test == 0 then
            drawfont(8*8-5,8*23,font[1],"-   NEW GAME   -")
        end
        if sound_test == 1 then
            drawfont(8*8-5,8*23,font[1],"-  MUSIC ROOM  -")
        end
        -- sound test enabler
        if pad_thisframe["left"] then
            sound_test = 0
        end
        if pad_thisframe["right"] then
            sound_test = 1
        end
        -- check for Konami Code steps and activate alternate SSL lyrics
        if pad_thisframe["up"] then
            if konami_code == 0 then
                konami_code = konami_code + 1;
            end
            if konami_code == 1 then
                konami_code = konami_code + 1;
            end
        end
        if pad_thisframe["down"] then
            if konami_code == 2 then
                konami_code = konami_code + 1;
            end
            if konami_code == 3 then
                konami_code = konami_code + 1;
            end
        end
        if pad_thisframe["left"] then
            if konami_code == 4 then
                konami_code = konami_code + 1;
            end
            if konami_code == 6 then
                konami_code = konami_code + 1;
            end
        end
        if pad_thisframe["right"] then
            if konami_code == 5 then
                konami_code = konami_code + 1;
            end
            if konami_code == 7 then
                konami_code = konami_code + 1;
            end
        end
        if pad_thisframe["B"] then
            if konami_code == 8 then
                konami_code = konami_code + 1;
            end
        end
        if pad_thisframe["A"] then
            if konami_code == 9 then
                konami_code = konami_code + 1;
                -- enable alternate lyrics
                enable_alternate_ssl = 1;
                -- enable Konami timeout
                konami_timeout = 60;
                -- play Konami Code sfx
                play_konami_sfx();
            end
        end
    end
end

function randomize()
    -- randomize the music and instrument set
    music = math.random(0,7)
    instruments = (math.random(0,15))*2 -- only an even value works for the music to play properly
    -- 1/4 chance of tempo modifier.
    tempo_random = math.random(0,3)
    -- if tempo modifier, change instrument to fast AKoE version instruments (song 0C set)
    if tempo_random == 0 then
        -- if not Happy Chinese Festival ("fast flag" for this glitches the game music)
        if music ~= 1 then
            -- add tempo modifier flag (like fast AKoE from level 12)
            tempo_modifier = 1
        else
            tempo_modifier = 0
        end
    else
        tempo_modifier = 0
    end
    -- apply the valid tempo with modifier
    tempo = tempos[music+1]-tempo_modifier
    -- calculate variation number
    variation_number = (instruments+1)/2 + (16*(tempo_modifier)) + 0.5
end

function draw_song_names()
    -- read byte $0004 to determine if game currently not on title screen
    if memory.readbyte(0x0004) ~= 0 then
        -- if tempo modifier not applied
        if tempo_modifier == 0 then
            -- if music instrument set is the same as music number
            if music == (instruments/2) then
                -- draw song name original ver.
                --gui.text(5,224,"o|\ "..song_names[music+1].." original ver.");
                drawfont(8*1-5,8*28,font[1], "@"..song_names[music+1].." orig.".."                ")
            else
                -- draw variation number
                --gui.text(5,224,"o|\ "..song_names[music+1].." var. "..variation_number);
                drawfont(8*1-5,8*28,font[1], "@"..song_names[music+1].." var."..variation_number.."                ")
            end
        else
            -- draw variation number
            --gui.text(5,224,"o|\ "..song_names[music+1].." var. "..variation_number);
            drawfont(8*1-5,8*28,font[1], "@"..song_names[music+1].." var."..variation_number.."                ")
        end
        -- finish with a note symbol
        draw_note(0, 224);
    end
end

function draw_copy(x,y)
    -- draw the copyright symbol
    gui.pixel(x, y+2, "#FFFFFF")
    gui.pixel(x, y+3, "#FFFFFF")
    gui.pixel(x, y+4, "#FFFFFF")
    gui.pixel(x, y+5, "#FFFFFF")
    gui.pixel(x+1, y+1, "#FFFFFF")
    gui.pixel(x+1, y+6, "#FFFFFF")
    gui.pixel(x+2, y, "#FFFFFF")
    gui.pixel(x+2, y+7, "#FFFFFF")
    gui.pixel(x+2, y+3, "#FFFFFF")
    gui.pixel(x+2, y+4, "#FFFFFF")
    gui.pixel(x+3, y, "#FFFFFF")
    gui.pixel(x+3, y+7, "#FFFFFF")
    gui.pixel(x+3, y+2, "#FFFFFF")
    gui.pixel(x+3, y+5, "#FFFFFF")
    gui.pixel(x+4, y, "#FFFFFF")
    gui.pixel(x+4, y+7, "#FFFFFF")
    gui.pixel(x+4, y+2, "#FFFFFF")
    gui.pixel(x+4, y+5, "#FFFFFF")
    gui.pixel(x+5, y, "#FFFFFF")
    gui.pixel(x+5, y+7, "#FFFFFF")
    gui.pixel(x+6, y+1, "#FFFFFF")
    gui.pixel(x+6, y+6, "#FFFFFF")
    gui.pixel(x+7, y+2, "#FFFFFF")
    gui.pixel(x+7, y+3, "#FFFFFF")
    gui.pixel(x+7, y+4, "#FFFFFF")
    gui.pixel(x+7, y+5, "#FFFFFF")
end

function draw_note(x,y)
    -- draw the little note icon
    gui.pixel(x, y+4, "#FFFFFF")
    gui.pixel(x, y+5, "#FFFFFF")
    gui.pixel(x+1, y+3, "#FFFFFF")
    gui.pixel(x+1, y+4, "#FFFFFF")
    gui.pixel(x+1, y+5, "#FFFFFF")
    gui.pixel(x+1, y+6, "#FFFFFF")
    gui.pixel(x+2, y+3, "#FFFFFF")
    gui.pixel(x+2, y+4, "#FFFFFF")
    gui.pixel(x+2, y+5, "#FFFFFF")
    gui.pixel(x+2, y+6, "#FFFFFF")
    gui.pixel(x+3, y+3, "#FFFFFF")
    gui.pixel(x+3, y+4, "#FFFFFF")
    gui.pixel(x+3, y+5, "#FFFFFF")
    gui.pixel(x+3, y+6, "#FFFFFF")
    gui.pixel(x+4, y+0, "#FFFFFF")
    gui.pixel(x+4, y+1, "#FFFFFF")
    gui.pixel(x+4, y+2, "#FFFFFF")
    gui.pixel(x+4, y+3, "#FFFFFF")
    gui.pixel(x+4, y+4, "#FFFFFF")
    gui.pixel(x+4, y+5, "#FFFFFF")
    gui.pixel(x+5, y+1, "#FFFFFF")
    gui.pixel(x+6, y+2, "#FFFFFF")
end

function restart_song()
    -- hacky way to restart a song, by skipping to the end of Speak Softly Love
    memory.writebyte(0x0DE4, 0x1C)
    memory.writebyte(0x0DE3, 0x64)
end

function writebyteppu(a,v)
    memory.writebyte(0x2001,0x00) -- Turn off rendering
    memory.readbyte(0x2002) -- PPUSTATUS (reset address latch)
    memory.writebyte(0x2006,math.floor(a/0x100)) -- PPUADDR high byte
    memory.writebyte(0x2006,a % 0x100) -- PPUADDR low byte
    memory.writebyte(0x2007,v) -- PPUDATA
    memory.writebyte(0x2001,0x1e) -- Turn on rendering
end

function erase_gui()
    writebyteppu(0x2057, 0x00)
    writebyteppu(0x2058, 0x00)
    writebyteppu(0x2059, 0x00)
    writebyteppu(0x205A, 0x00)
    writebyteppu(0x205B, 0x00)
    writebyteppu(0x20B6, 0x00)
    writebyteppu(0x20B7, 0x00)
    writebyteppu(0x20B8, 0x00)
    writebyteppu(0x20B9, 0x00)
    writebyteppu(0x20BA, 0x00)
    writebyteppu(0x20BB, 0x00)
    writebyteppu(0x20BC, 0x00)
    writebyteppu(0x2117, 0x00)
    writebyteppu(0x2118, 0x00)
    writebyteppu(0x2119, 0x00)
    writebyteppu(0x211A, 0x00)
    writebyteppu(0x211B, 0x00)
end

function erase_scores()
    -- erase first 0x38 bytes of OAM
    for oam=0,0x38,1 do
        memory.writebyte(0x200+oam, 0x00)
    end
end

function process_sound_test()
    snd = sound.get()
    -- read byte $0004 to determine if game currently not on title screen
    if memory.readbyte(0x0004) ~= 0 then
        -- if sound test on
        if sound_test == 1 then
            -- disable falling
            memory.writebyte(0x0057, 0x02)
            memory.writebyte(0x0059, 0x00)
            memory.writebyte(0x038C, 0x00)
            -- disable next jewel
            memory.writebyte(0x005F, 0x00)
            memory.writebyte(0x0060, 0x00)
            memory.writebyte(0x0061, 0x00)
            -- draw rectangle over playfield
            gui.rect(-3+8*7, 8*2, 5+8*18, -1+8*28, "#000000")
            -- draw rectangle over next jewel
            gui.rect(-3+8*3, 8*2, 4+8*4, -1+8*8, "#000000")
            -- draw sound test menu
            drawfont(8*7-2,8*3,font[1], "-MUSIC ROOM-")
            -- if lyrics timeout > 0 display chosen lyrics option
            if lyrics_timeout > 0 then
                drawfont(8*7-2,8*3,font[1],lyrics_option_texts_short[lyrics_option])
                lyrics_timeout = lyrics_timeout - 1;
            end
            drawfont(8*7-2,8*5,font[1], " SONG:   "..string.format("%02x", music))
            drawfont(8*7-2,8*6,font[1], " INSTR.: "..string.format("%02x", instruments/2))
            if tempo_modifier == 0 then
                drawfont(8*7-2,8*7,font[1], " TEMPO: OFF")
            end
            if tempo_modifier == 1 then
                drawfont(8*7-2,8*7,font[1], " TEMPO:  ON")
            end
            drawfont(8*7-2,8*9,font[1], "SQ1 SQ2 TRI")
            -- get volumes
            sq1_volume = snd.rp2a03.square1.volume*15
            sq2_volume = snd.rp2a03.square2.volume*15
            tri_volume = snd.rp2a03.triangle.volume*15
            -- draw volumes
            gui.rect(-3+8*8, -1+8*26, 4+8*8, -1+8*26-sq1_volume*8, "#E40058")
            gui.rect(-3+8*12, -1+8*26, 4+8*12, -1+8*26-sq2_volume*8, "#3CBCFC")
            gui.rect(-3+8*16, -1+8*26, 4+8*16, -1+8*26-sq2_volume*8, "#80D010")
            -- draw notes
            note = math.floor((snd.rp2a03.square1.midikey - 21) % 12);
            octave = math.floor((snd.rp2a03.square1.midikey - 12) / 12);
            semitone = tostring(semitones[note + 1]) .. octave;
            drawfont(8*7-2,8*26,font[1], semitone)
            note = math.floor((snd.rp2a03.square2.midikey - 21) % 12);
            octave = math.floor((snd.rp2a03.square2.midikey - 12) / 12);
            semitone = tostring(semitones[note + 1]) .. octave;
            drawfont(8*11-2,8*26,font[1], semitone)
            note = math.floor((snd.rp2a03.triangle.midikey - 21) % 12);
            octave = math.floor((snd.rp2a03.triangle.midikey - 12) / 12);
            semitone = tostring(semitones[note + 1]) .. octave;
            drawfont(8*15-2,8*26,font[1], semitone)
            -- draw note
            draw_note(-3+8*7, 8*5+sound_sel*8)
            -- erase GUI
            erase_gui()
            -- erase scores
            erase_scores()
            -- process timeout
            if sound_timeout > 0 then
                sound_timeout = sound_timeout - 1
            end
            -- disable tempo modifier for Happy Chinese Festival
            if music == 1 then
                tempo_modifier = 0
            end
            -- calculate variation number
            variation_number = (instruments+1)/2 + (16*(tempo_modifier)) + 0.5
            if pad_thisframe["select"] then
                if lyrics_timeout <= 0 then
                    -- play switch sfx
                    play_switch_sfx();
                    -- enable karaoke mode
                    lyrics_option = lyrics_option + 1
                    -- if karaoke mode already enabled, disable it
                    if lyrics_option > 2 then
                        lyrics_option = 1
                    end
                    -- enable lyrics info text
                    lyrics_timeout = 60
                end
            end
            -- process menu
            if pad_thisframe["up"] then
                if sound_timeout <= 0 then
                    -- play switch sfx
                    play_switch_sfx();
                    -- set timeout
                    sound_timeout = 10
                    -- subtract 1 from option menu
                    if sound_sel > 0 then
                        sound_sel = sound_sel - 1
                    end
                end
            end
            if pad_thisframe["down"] then
                if sound_timeout <= 0 then
                    -- play switch sfx
                    play_switch_sfx();
                    -- set timeout
                    sound_timeout = 10
                    -- add 1 to option menu
                    if sound_sel < 2 then
                        sound_sel = sound_sel + 1
                    end
                end
            end
            -- process song switching
            if sound_sel == 0 then
                if pad_thisframe["left"] then
                    if sound_timeout <= 0 then
                        -- play switch sfx
                        play_switch_sfx();
                        -- set timeout
                        sound_timeout = 10
                        -- change song
                        if music > 0 then
                            music = music - 1
                        end
                        -- restart song
                        restart_song()
                    end
                end
                if pad_thisframe["right"] then
                    if sound_timeout <= 0 then
                        -- play switch sfx
                        play_switch_sfx();
                        -- set timeout
                        sound_timeout = 10
                        -- change song
                        if music < 7 then
                            music = music + 1
                        end
                        -- restart song
                        restart_song()
                    end
                end
            end
            -- process instrument switching
            if sound_sel == 1 then
                if pad_thisframe["left"] then
                    if sound_timeout <= 0 then
                        -- play switch sfx
                        play_switch_sfx();
                        -- set timeout
                        sound_timeout = 10
                        -- change instrument set
                        if instruments > 0 then
                            instruments = instruments - 2
                        end
                        -- restart song
                        restart_song()
                    end
                end
                if pad_thisframe["right"] then
                    if sound_timeout <= 0 then
                        -- play switch sfx
                        play_switch_sfx();
                        -- set timeout
                        sound_timeout = 10
                        -- change instrument set
                        if instruments < 30 then
                            instruments = instruments + 2
                        end
                        -- restart song
                        restart_song()
                    end
                end
            end
            -- process tempo switching
            if sound_sel == 2 then
                if pad_thisframe["left"] then
                    if sound_timeout <= 0 then
                        -- play switch sfx
                        play_switch_sfx();
                        -- set timeout
                        sound_timeout = 10
                        -- change tempo modifier
                        tempo_modifier = 0
                        -- apply the valid tempo with modifier
                        tempo = tempos[music+1]-tempo_modifier
                        -- restart song
                        restart_song()
                    end
                end
                if pad_thisframe["right"] then
                    if sound_timeout <= 0 then
                        -- play switch sfx
                        play_switch_sfx();
                        -- set timeout
                        sound_timeout = 10
                        -- change tempo modifier
                        tempo_modifier = 1
                        -- apply the valid tempo with modifier
                        tempo = tempos[music+1]-tempo_modifier
                        -- restart song
                        restart_song()
                    end
                end
            end
        end
    end
end

randomize()
while (true) do
    -- randomize music on level clear
    memory.registerexecute(0xEC86, 8, 
    function()
        randomize()
    end
    )
    -- write to memory before game reads instruments
    memory.registerexecute(0xF188, 57, 
    function()
        memory.writebyte(0x000C, instruments)
        memory.writebyte(0x000D, instruments)
        memory.writebyte(0x006D, music+math.floor(game_loop)*16)
        memory.writebyte(0x05F2, tempo)
    end
    )
    -- write to memory before game reads song to play
    memory.registerexecute(0xF04F, 70, 
    function()
        memory.writebyte(0x006D, music+math.floor(game_loop)*16)
        memory.writebyte(0x05F2, tempo)
    end
    )
    -- constantly calculate game loop
    calculate_level();
    -- constantly write music bytes
    memory.writebyte(0x000C, instruments)
    memory.writebyte(0x000D, instruments)
    memory.writebyte(0x006D, music+math.floor(game_loop)*16)
    memory.writebyte(0x05F2, tempo)
    -- process gamepad input
    process_gamepad();
    -- draw song names
    draw_song_names();
    -- process lyrics
    process_lyrics();
    -- process title screen
    process_title();
    -- process sound test
    process_sound_test();
    -- advance frame
	FCEU.frameadvance();
end;
