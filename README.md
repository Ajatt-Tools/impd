# Immersion pod

[![Chat](https://img.shields.io/badge/chat-join-green)](https://tatsumoto-ren.github.io/blog/join-our-community.html)
[![Channel](https://shields.io/badge/channel-subscribe-blue?logo=telegram&color=3faee8)](https://t.me/ajatt_tools)
![License](https://img.shields.io/github/license/Ajatt-Tools/impd)
[![Patreon](https://img.shields.io/badge/patreon-support-orange)](https://www.patreon.com/bePatron?u=43555128)

> AJATT-style passive listening and condensed audio without bloat.

Passive immersion is one of the key activities in
[AJATT](http://www.alljapaneseallthetime.com/blog/all-japanese-all-the-time-ajatt-how-to-learn-japanese-on-your-own-having-fun-and-to-fluency/).
This program lets
[mpd](https://wiki.archlinux.org/index.php/Music_Player_Daemon)
users convert foreign language movies and TV shows to audio and use it for passive listening.
`impd` supports **condensed audio** and creates it by default
if it finds subtitles in the container or externally.

## Installation

Arch Linux users can install the
[impd-git](https://aur.archlinux.org/packages/impd-git/)
AUR package and skip to [Configuration](#configuration).

1) Install dependencies

    * Mandatory:
        * [mpd](https://wiki.archlinux.org/index.php/Music_Player_Daemon)
        * [FFmpeg](https://wiki.archlinux.org/index.php/FFmpeg)

    * Optional:
        * [mpc](https://archlinux.org/packages/extra/x86_64/mpc/) - Interaction with `mpd`.
        * [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/) - Desktop notifications.
        * [youtube-dl](https://wiki.archlinux.org/index.php/Youtube-dl) - Adding audio from Youtube.

2) Clone the repo
    ```
    $ git clone 'https://github.com/Ajatt-Tools/impd.git' ~/.local/share/impd
    ```
3) Link the `impd` executable somewhere in your `PATH`
    ```
    $ ln -s ~/.local/share/impd/impd ~/.local/bin/impd
    ```

## Configuration

To configure the program create a config file at `~/.config/immersionpod/config`.

**Available options:**

* `langs` - A comma-separated list of languages, in the order of preference.
    `impd` will try to extract audio and use subtitles in the specified language.
    If the required language is not found, it will try the next preference.
    If you don't know the code for your language, run `impd probe` on a desired video file.
* `prefer_internal_subs` - Try to use internal subtitles when creating condensed audio.
    If `impd` fails to do so, it tries external subtitles.
    If the option is set to `no`, `impd` tries external subtitles first.
* `video_dir` - The default directory where your video files are stored.
    The directory is searched for recently added files when you call `impd rotate`.
* `bitrate` - Audio bitrate.
    It is recommended to keep it rather low to save disk space because `impd` deals with speech, not music.
    Speech doesn't require high bitrates.
* `recent_threshold` - A file is considered recent if it has been modified in the last X days.
    Audio files that are no longer recent get archived if you call `impd archive`,
    and videos get skipped if you call `impd add_recent`.
* `padding` - Set a pad to the dialog timings. For example, 0.5 = half a second.
* `music_dir` - Custom music directory. Set it only when `impd` fails to automatically detect your music directory.

**Example config file:**

```
langs=jpn,eng,rus,ukr,fre,spa,ger,por,ita,ara,dut
prefer_internal_subs=yes
video_dir=~/Videos/ongoing
bitrate=32k
recent_threshold=10
padding=0.2
```

The config file is sourced so don't put stuff like `$ rm -rf ~/*` there, or it will bite you back.

## Usage

**Tip:** If you store all your immersion material in `video_dir` like me
the only command you are going to need is `impd rotate`.

**Available commands:**

* `add [OPTION] FILE` - Convert videos to audio and add them to Immersion pod.

    **Arguments for `impd add`:**
    * `-r`, `--recent` - Add files modified in the last `recent_threshold` days
    from your video directory to Immersion pod.
    * `-s`, `--stdin` - Read filenames from stdin.
* `condense -i video [-o audio] [-s subtitles]` - Make condensed audio and store it in an arbitrary location.
* `archive` - Move episodes older than `recent_threshold` days to the archive folder.
* `reshuffle` - Re-add files to the playlist, shuffle them and start playing.
* `rotate` - Archive old immersion material and make new based on videos in your video directory.
    Equivalent to `impd add --recent` > `impd archive` > `impd reshuffle`.

**Optional arguments:**
* `-f`, `--force` - Overwrite existing files.
* `-n`, `--no-condense` - Don't condense audio.

**Examples:**

```
$ impd add -f 'video.mkv'
$ impd add --recent
$ find /mnt/videos/ | impd add --stdin
$ impd rotate
```

**Tip:** Add `impd rotate` as a cronjob or bind it to any key in your DE, WM, sxhkd, xbindkeysrc, etc.

Additionally, you can use `impd` to perform miscellaneous operations on media.

* `to_srt file.ass file.srt` - Convert `file` to `srt`.
* `make_condensed video.mkv condensed.ogg` - Convert video to condensed audio.
* `extract_audio video.mkv audio.ogg` - Extract audio from video without condensing.
* `extract_subtitles video.mkv subtitles.srt` - Extract internal subtitles.
* `probe [a|s] video.mkv` - Print tracks available in the container.

## Condensing

For condensing to work the video files passed to `impd` should have embedded subtitles
or external .srt/.ass subtitles should be placed in the same folder as the video files
or in a subfolder relative to the directory that contains the video files.
External subtitles should have the same names as the corresponding video files except for the extensions.

## Contributions

If you want to discuss this program, have found a bug, or want to participate in the development,
please join [our community](https://tatsumoto-ren.github.io/blog/join-our-community.html).
I look forward to suggestions and pull requests!

My special thanks to all my
[Patreon](https://www.patreon.com/bePatron?u=43555128)
supporters for making this project possible.
