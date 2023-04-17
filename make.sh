#!/usr/bin/env sh

### Script: make.sh
##
## All Sailor Moon Memories の動画を作成する。
##
## Metadata:
##
##   id - 69fc451a-d276-4fc4-9f7c-cff01b99319b
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.1
##   date - 2023-04-17
##   since - 2023-04-09
##   copyright - Copyright (C) 2023-2023 qq542vev. Some rights reserved.
##   license - <CC-BY at https://creativecommons.org/licenses/by/4.0/>
##   package - all-sailor-moon-memories
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/all-sailor-moon-memories>
##   * <Bag report at https://github.com/qq542vev/all-sailor-moon-memories/issues>

set -efu
umask '0022'
readonly "LC_ALL_ORG=${LC_ALL-}"
LC_ALL='C'
IFS=$(printf ' \t\n_'); IFS="${IFS%_}"
PATH="${PATH-}${PATH:+:}$(command -p getconf 'PATH')"
UNIX_STD='2003' # HP-UX POSIX mode
XPG_SUS_ENV='ON' # AIX POSIX mode
XPG_UNIX98='OFF' # AIX UNIX 03 mode
POSIXLY_CORRECT='1' # GNU Coreutils POSIX mode
COMMAND_MODE='unix2003' # macOS UNIX 03 mode
export 'LC_ALL' 'IFS' 'PATH' 'UNIX_STD' 'XPG_SUS_ENV' 'XPG_UNIX98' 'POSIXLY_CORRECT' 'COMMAND_MODE'

readonly 'downloads=
youtube:cBRYceV7b1Q=https://www.youtube.com/watch?v=cBRYceV7b1Q
youtube:hj_xSv0F76Q=https://www.youtube.com/watch?v=hj_xSv0F76Q
youtube:coShQEyM0ic=https://www.youtube.com/watch?v=coShQEyM0ic
'
readonly 'options=--abort-on-error --continue --ignore-config --no-cache-dir --retries 100'
readonly 'format=%(extractor)s:%(id)s.%(format_id)s.%(ext)s'

mkdir -p -- 'videos' 'audios'

for line in ${downloads}; do
	name="${line%%=*}"
	url="${line#*=}"

	if [ '!' -f "videos/${name}" ]; then
		yt-dlp ${options} --format 'bestvideo[width=640][height=480]' --output "videos/${format}" -- "${url}"
		rm -fr -- "videos/${name}"
		ln -s -- "$(yt-dlp ${options} --format 'bestvideo[width=640][height=480]' --output "${format}" --get-filename -- "${url}")" "videos/${name}"
	fi

	if [ '!' -f "audios/${name}" ]; then
		yt-dlp ${options} --format 'bestaudio' --output "audios/${format}" -- "${url}"
		rm -fr -- "audios/${name}"
		ln -s -- "$(yt-dlp ${options} --format 'bestaudio' --output "${format}" --get-filename -- "${url}")" "audios/${name}"
	fi

	videos="${videos-} -i videos/${name}"
	audios="${audios-} -i audios/${name}"
done

ffmpeg ${videos} ${audios} \
	-filter_complex '
		color=s=1280x960:c=black[background];
		[1:v]trim=start=02.16666667:end=01\\:34.3,setpts=PTS-STARTPTS+0.3/TB[trimmed_v];
		[4:a]atrim=start=02.16666667:end=01\\:34.3,asetpts=PTS-STARTPTS+0.3/TB[trimmed_a];
		[1:v]trim=start=00:end=02,setpts=PTS-STARTPTS+7/TB[logo];
		[background][0:v]overlay=x=0:y=0[1video];
		[1video][trimmed_v]overlay=x=640:y=0[2video];
		[2video][2:v]overlay=x=0:y=480[3video];
		[3video][logo]overlay=x=640:y=480
	' \
	-map '3:a' -map '[trimmed_a]' -map '5:a' \
	-c:v libx264 -r 30 -fps_mode cfr -crf 0 -qp 0 -preset placebo -tune animation \
	-c:a flac -ar 48000 -ac 2 -compression_level 12 \
	-metadata 'title=All Sailor Moon Memories' \
	-metadata:s:a:0 'language=jpn' \
	-metadata:s:a:0 'title=sailor moon memories opening 2nd version セーラームーン' \
	-metadata:s:a:0 'description=Source: https://www.youtube.com/watch?v=cBRYceV7b1Q' \
	-metadata:s:a:1 'language=spa' \
	-metadata:s:a:1 'title=Opening sailor moon MemorieS' \
	-metadata:s:a:1 'description=Source: https://www.youtube.com/watch?v=hj_xSv0F76Q' \
	-metadata:s:a:2 'language=spa' \
	-metadata:s:a:2 'title=sailor moon memories opening' \
	-metadata:s:a:2 'description=Source: https://www.youtube.com/watch?v=coShQEyM0ic' \
	-to '01:33' all-sailor-moon-memories.mkv
