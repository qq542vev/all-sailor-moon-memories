#!/usr/bin/env bash

### Script: make.sh
##
## All Sailor Moon Memories の動画を作成する。
##
## Metadata:
##
##   id - 69fc451a-d276-4fc4-9f7c-cff01b99319b
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 2.0.1
##   date - 2023-05-23
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

readonly "urls=$(
	cat <<-'__EOF__'
	https://www.youtube.com/watch?v=cBRYceV7b1Q	youtube:cBRYceV7b1Q	copy	acopy	jpn	sailor moon memories opening 2nd version セーラームーン
	https://www.youtube.com/watch?v=hj_xSv0F76Q	youtube:hj_xSv0F76Q	trim=start=02.16666666:end=01\\:34.3,setpts=PTS-STARTPTS+0.3/TB	atrim=start=02.16666666:end=01\\:34.3,asetpts=PTS-STARTPTS+0.3/TB	spa	Opening sailor moon MemorieS
	https://www.youtube.com/watch?v=coShQEyM0ic	youtube:coShQEyM0ic	copy	acopy	spa	sailor moon memories opening
	__EOF__
)"
readonly options=(
	'--abort-on-error' '--continue'
	'--ignore-config' '--no-cache-dir'
	'--retries' '100'
)
readonly 'format=%(extractor)s:%(id)s.%(format_id)s.%(ext)s'
readonly 'width=640'
readonly 'height=480'
readonly "xy=$(awk -v "n=$(printf '%s' "${urls}" | grep -c '^')" -- 'BEGIN { s = sqrt(n); r = int(s); printf("%d", (r == s ? r : r + 1)); }')"

mkdir -p -- 'videos' 'audios'

input=()
map=('-map' "[overlay$(printf '%s' "${urls}" | grep -c '^')]")
metadata=('-metadata' 'title=All Sailor Moon Memories')
filter="color=size=$((width * xy))x$((height * xy)):color=black:rate=30[background];[2:v]trim=start=00:end=02,setpts=PTS-STARTPTS+7/TB[logo];[background][logo]overlay=x=640:y=480[overlay0]"

while IFS='	' read -r i url filename vfilter afilter language title; do
	if [ '!' -f "videos/${filename}" ]; then
		yt-dlp "${options[@]}" --format 'bestvideo[width=640][height=480]' --output "videos/${format}" -- "${url}"

		rm -fr -- "videos/${filename}"
		ln -s -- "$(yt-dlp "${options[@]}" --format 'bestvideo[width=640][height=480]' --print "${format}" -- "${url}")" "videos/${filename}"
	fi

	if [ '!' -f "audios/${filename}" ]; then
		yt-dlp "${options[@]}" --format 'bestaudio' --output "audios/${format}" -- "${url}"

		rm -fr -- "audios/${filename}"
		ln -s -- "$(yt-dlp "${options[@]}" --format 'bestaudio' --print "${format}" -- "${url}")" "audios/${filename}"
	fi

	input+=('-i' "videos/${filename}" '-i' "audios/${filename}")
	map+=('-map' "[audio${i}]")
	metadata+=(
		"-metadata:s:a:${i}" "language=${language}"
		"-metadata:s:a:${i}" "title=${title}"
		"-metadata:s:a:${i}" "description=Source: ${url}"
	)
	filter="${filter};[$((i * 2)):v]${vfilter}[video${i}];[overlay${i}][video${i}]overlay=x=$((i % xy * width)):y=$((i / xy * height))[overlay$((i + 1))];[$(((i * 2) + 1)):a]${afilter}[audio${i}]"
done <<<"$(printf '%s\n' "${urls}" | nl -v '0' | sed -e 's/^ *//')"

ffmpeg \
	"${input[@]}" -filter_complex "${filter}" "${map[@]}" "${metadata[@]}" \
	-c:v libx264 -fps_mode cfr -crf 0 -qp 0 -preset placebo -tune animation \
	-c:a flac -ar 48000 -ac 2 -compression_level 12 \
	-to '01:33' -- 'all-sailor-moon-memories.mkv'
