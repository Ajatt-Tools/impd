# Immersion pod

[![AUR](https://img.shields.io/badge/AUR-install-blue.svg)](https://aur.archlinux.org/packages/impd-git/)
[![Chat](https://img.shields.io/badge/chat-join-green)](https://tatsumoto-ren.github.io/blog/join-our-community.html)
[![Channel](https://shields.io/badge/channel-subscribe-blue?logo=telegram&color=3faee8)](https://t.me/ajatt_tools)
[![Patreon](https://img.shields.io/badge/patreon-support-orange)](https://www.patreon.com/bePatron?u=43555128)
![License](https://img.shields.io/github/license/Ajatt-Tools/impd)

> AJATT-style passive listening and condensed audio without bloat.

Passive immersion is one of the key activities in
[AJATT](https://tatsumoto.neocities.org/blog/foreword.html#all-japanese-all-the-time).
This program lets
[mpd](https://wiki.archlinux.org/index.php/Music_Player_Daemon)
users convert foreign language movies and TV shows to audio and use it for passive listening.
`impd` supports **condensed audio** and creates it by default
if it finds subtitles in the container or externally.

## Installation

### Arch Linux and pacman-based distros

Arch Linux users can install the
[impd-git](https://aur.archlinux.org/packages/impd-git/)
AUR package and skip to [Configuration](#configuration).

### Other distros

If you want to package `impd` for your distro and know how to do it,
please create a pull request.

<details>

<summary>Manual installation</summary>

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
   Alternatively, `cd` into the folder and run `make install`.

</details>

## Configuration

To configure the program create a config file at `~/.config/immersionpod/config`.

**Available options:**

* `langs`.
  A comma-separated list of languages, in the order of preference.
  `impd` will try to extract audio and use subtitles in the specified language.
  If the required language is not found, it will try the next preference.
  If you don't know the code for your language, run `impd probe` on a desired video file.
* `prefer_internal_subs`.
  If set to `yes`, try to use internal subtitles when creating condensed audio.
  If `impd` fails to do so, it tries external subtitles.
  If the option is set to `no`, `impd` tries external subtitles first.
* `video_dir`. The default directory where your video files are stored.
  The directory is searched for recently added files when you call `impd rotate`.
* `bitrate`. Audio bitrate.
  It is recommended to keep it rather low to save disk space because `impd` deals with speech, not music.
  Speech doesn't require high bitrates.
* `recent_threshold`. A file is considered recent if it has been modified in the last X days.
  Audio files that are no longer recent get archived if you call `impd archive`,
  and videos get skipped if you call `impd add_recent`.
* `padding`. Set a pad to the dialog timings. For example, 0.5 = half a second.
* `music_dir`. Custom music directory.
  Set it only when `impd` fails to automatically detect your music directory.
* `line_skip_pattern`. Skip subtitle lines matching this RegExp.
  If empty, no lines will be skipped.
Can be used to skip openings and endings by matching lines like `♪〜`.
* `filename_skip_pattern`. Perl RegExp to match the filename of the input file.
  If it matches, `impd` skips the file.
  By default, it is set to skip filenames that contain `NCOP` or `NCED`.
* `extract_audio_add_args`.
  Defines an array of additional arguments which should be passed to `ffmpeg`
  when extracting audio tracks from videos.

**Example config file:**

```
langs=japanese,jpn,jp,ja,english,eng,en,rus,ukr,fre,spa,ger,por,ita,ara,dut
prefer_internal_subs=yes
video_dir=~/Videos/ongoing
bitrate=32k
recent_threshold=10
padding=0.2
line_skip_pattern="^♪〜$|^〜♪$"
filename_skip_pattern="NCOP|NCED"
extract_audio_add_args=(-af loudnorm=I=-16:TP=-1.5:LRA=11)
```

If a value is omitted from the config file, the default value will be used.
The config file is sanitized and then sourced.

## Usage

**Tip:** If you store all your immersion material in `video_dir` like me
the only command you are going to need most of the time is `impd rotate`.

**Available commands:**

Convert videos to audio and add them to Immersion pod.
`impd` will guess what audio and subtitles to use:

```
$ impd add [OPTION] FILE
```

Options for `impd add`:

* `-r`, `--recent`.
  Add all files modified in the last `recent_threshold` days
  from your video directory to Immersion pod.
* `-s`, `--stdin`.
  Read filenames from stdin.

If FILE is an audio file, it is added as well.
You can use this to add existing podcasts or audiobooks to impd.

Make condensed audio and store it in an arbitrary location:

```
$ impd condense -i video [-o output audio] [-s subtitle file] [-t subtitle track number]
```

This function gives more precise control than `add`.
If you don't specify `output audio`, the standard Immersion pod directory will be used.
If you specify `subtitle file`, an **external** subtitle file will be used.
If you specify `subtitle track number`, an **internal** subtitle track number will be used.
Run `impd probe FILE` to output tracks and their corresponding numbers.

Move episodes older than `recent_threshold` days to the archive folder:

```
$ impd archive
```

Re-add files to the playlist, shuffle them and start playing:

```
$ impd reshuffle
```

Archive old immersion material and make new based on videos in your video directory:

```
$ impd rotate
```

Equivalent to calling `impd add --recent`, `impd archive` and `impd reshuffle`.

**Global options:**

* `-f`, `--force`.
  Overwrite existing files.
* `-n`, `--no-condense`.
  Don't condense audio.

## Examples

Add an arbitrary video to Immersion pod. Condense if possible:

```
$ impd add -f 'video.mkv'
```

Add all recently downloaded videos to Immersion pod. Condense if possible:

```
$ impd add --recent
```

Use the `find` utility to search for specific videos.
Pipe the output to `impd`:

```
$ find /mnt/videos/ | impd add --stdin
```

Rotate.
Archive old episodes and add newly downloaded ones:

```
$ impd rotate
```

**Tip:** Add `impd rotate` as a cronjob or bind it to any key in your DE, WM, sxhkd, xbindkeysrc, etc.

Condense audio on demand:

```
$ impd condense -i 'video.mkv' -o 'audio.ogg' -s 'subtitles.srt'
```

## Miscellaneous

Convert `file` to `ass` or `srt`:

```
$ impd sub_conv file.srt file.ass
$ impd sub_conv file.ass file.srt
```

Extract audio from video without condensing:

```
$ impd extract_audio 'video.mkv' audio.ogg
```

Extract internal subtitles.
Format is guessed based on extension:

```
$ impd extract_subtitles 'video.mkv' subtitles.srt
$ impd extract_subtitles 'video.mkv' subtitles.ass
```

Extract subtitles from all videos in a folder:

```
for video in ./*.mkv; do
    impd extract_subtitles "$video" "${video%.*}.ass"
done
```

Print video, audio and subtitle tracks available in the container:

```
$ impd probe 'video.mkv'
```

Add an arbitrary audio to Immersion pod:

```
$ impd add ~/podcast.mp3
$ impd add 'https://podcasts.com/podcast.mp3'
```

Download and automatically add podcasts or YouTube videos to Immersion pod.

If you use
[Newsboat](https://wiki.archlinux.org/title/Newsboat),
you can define a macro to add a video or audio to Immersion pod.
Install
[tsp](https://aur.archlinux.org/packages/task-spooler/),
then open your `~/.config/newsboat/config` and add the macro:

```
browser firefox
macro i set browser "tsp impd add" ; open-in-browser ; set browser firefox -- "Add to Immersion pod"
```

Next time you open Newsboat,
you'll be able to press the macro-prefix (usually `,`) followed by `i` to call `impd add`.

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
