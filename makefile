#!/usr/bin/make -f

### Script: makefile
##
## ファイルを作成する。
##
## Usage:
##
## ------ Text ------
## make -f makefile
## ------------------
##
## Metadata:
##
##   id - ffa7a6e9-156b-4e1b-b7c3-1ecb89761c26
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   created - 2024-06-23
##   modified - 2025-06-26
##   copyright - Copyright (C) 2025-2025 qq542vev. Some rights reserved.
##   license - <CC-BY-4.0 at https://creativecommons.org/licenses/by/4.0/>
##   depends - echo, ffmpeg, mediainfo, xdg-open, yt-dlp
##   conforms-to - <https://pubs.opengroup.org/onlinepubs/9799919799/utilities/make.html>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/all-sailor-moon-memories>
##   * <Bag report at https://github.com/qq542vev/all-sailor-moon-memories/issues>

# Sp Targets
# ==========

.POSIX:

.PHONY: all infofile run clean rebuild help version

.SILENT: help version

.SUFFIXES: .mkv .txt

# Macro
# =====

VERSION = 1.0.0

MAIN_FILE = all-sailor-moon-memories.mkv
ID = cBRYceV7b1Q hj_xSv0F76Q coShQEyM0ic
VIDEO_DIR = videos
VIDEO_FILE = $(ID:%=$(VIDEO_DIR)/%.mkv)
YTDLP = yt-dlp --abort-on-error --continue --ignore-config --no-cache-dir --retries 100 --merge-output-format mkv --write-info-json
YOUTUBE_URL = https://www.youtube.com/watch?v=

# Build
# =====

all: $(MAIN_FILE)

# Video
# -----

MAIN_FILE: $(VIDEO_FILE)
	ffmpeg $(^:%=-i %) \
		-filter_complex " \
			color=size=1280x960:color=black:rate=30[bg]; \
			[1:v]trim=start=00:end=02,setpts=PTS-STARTPTS+7/TB[logo]; \
			[bg][logo]overlay=x=640:y=480[overlay0]; \
			[overlay0][0:v]overlay=x=0:y=0[overlay1]; \
			[1:v]trim=start=02.16666666:end=01\\\\:34.3,setpts=PTS-STARTPTS+0.3/TB[vid1]; \
			[overlay1][vid1]overlay=x=640:y=0[overlay2]; \
			[1:a]atrim=start=02.16666666:end=01\\\\:34.3,asetpts=PTS-STARTPTS+0.3/TB[aud1]; \
			[overlay2][2:v]overlay=x=0:y=480[overlay3] \
		" \
		-map '[overlay3]' -map '0:a' -map '[aud1]' -map '2:a' \
		-metadata 'title=All Sailor Moon Memories' \
		-metadata:s:a:0 'title=sailor moon memories opening 2nd version セーラームーン' \
		-metadata:s:a:0 'language=jpn' \
		-metadata:s:a:1 'title=Opening sailor moon MemorieS' \
		-metadata:s:a:1 'language=spa' \
		-metadata:s:a:2 'title=sailor moon memories opening' \
		-metadata:s:a:2 'language=spa' \
		-c:v:0 libx264 -fps_mode cfr -crf 0 -qp 0 -preset placebo -tune animation \
		-c:a:0 copy -c:a:1 flac -c:a:2 copy -ar 48000 -ac 2 -compression_level 12 \
		-to '01:33' -hide_banner -- '$(@)'

$(VIDEO_FILE):
	mkdir -p -- '$(@D)'
	$(YTDLP) -f bestvideo[width=640][height=480]+bestaudio -o '$(@)' -- '$(YOUTUBE_URL)$(@F:.mkv=)'

# Infofile
# --------

infofile: $(MAIN_FILE:.mkv=.txt) $(VIDEO_FILE:.mkv=.txt)
	
.mkv.txt:
	mediainfo '$(<)' >'$(@)'

# Run
# ===

run: $(MAIN_FILE)
	xdg-open '$(<)'

# Clean
# =====

clean:
	rm -rf $(MAIN_FILE) $(MAIN_FILE:.mkv=.txt) $(VIDEO_DIR)

rebuild: clean
	$(MAKE)

# Message
# =======

help:
	echo 'ファイルを作成する。'
	echo
	echo 'USAGE:'
	echo '  make [OPTION...] [MACRO=VALUE...] [TARGET...]'
	echo
	echo 'MACRO:'
	echo '  YTDLP yt-dlpのパス。'
	echo
	echo 'TARGET:'
	echo '  all     全てのファイルを作成する。'
	echo '  infofile'
	echo '          動画の情報ファイルを作成する。'
	echo '  run     メインのファイルを開く。'
	echo '  clean   作成したファイルを削除する。'
	echo '  rebuild cleanの後にallを実行する。'
	echo '  help    このヘルプを表示して終了する。'
	echo '  version バージョン情報を表示して終了する。'

version:
	echo '$(VERSION)'
