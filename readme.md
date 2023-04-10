<!-- Document: readme.md

	All Sailor Moon Memories のマニュアル

	Metadata:

		id - 4d5beda3-572f-471f-8c96-67e994c385b9
		author - <qq542vev at https://purl.org/meta/me/>
		version - 1.0.0
		date - 2023-04-09
		since - 2023-04-09
		copyright - Copyright (C) 2023-2023 qq542vev. Some rights reserved.
		license - <CC-BY at https://creativecommons.org/licenses/by/4.0/>
		package - all-sailor-moon-memories

	See Also:

		* <Project homepage at https://github.com/qq542vev/all-sailor-moon-memories>
		* <Bag report at https://github.com/qq542vev/all-sailor-moon-memories/issues>
-->

# All Sailor Moon Memories

All Sailor Moon Memories は Sailor Moon Memories の各動画を一覧表示した動画を作成する試みです。Sailor Moon Memoriesは [fabzt10](https://www.youtube.com/channel/UCi30Verb3Spu3oQiKnlmsqg) さんによって作成されたセーラームーンを題材にした幾つかの AMV(Anime Music Video) です。

現状では以下の３つの動画を分割して一覧表示します。

 * 左上 - [sailor moon memories opening 2nd version セーラームーン](https://www.youtube.com/watch?v=cBRYceV7b1Q)
 * 右上 - [Opening sailor moon MemorieS](https://www.youtube.com/watch?v=hj_xSv0F76Q)
 * 左下 - [sailor moon memories opening](https://www.youtube.com/watch?v=coShQEyM0ic)

# 動画を作成する

動画を作成するにはご使用のコンピューターに [yt-dlp](https://github.com/yt-dlp/yt-dlp) と [FFmpeg](https://ffmpeg.org/) がインストールされている必要があります。可能な限り最新版を使用してください。2023年04月09日現在、yt-dlp は [2023.03.04](https://github.com/yt-dlp/yt-dlp/releases/tag/2023.03.04)、FFmpeg は [5.1.1-static](https://ffmpeg.org/download.html) での組み合わせで動作することを確認しています。

[`make.sh`](make.sh) をダウンロードして、実行してください。YouTube から動画をダウンロードします。ダウンロードされた動画はカレントディレクトリの `./vidoes`, `./audios` 内に保存されます。その後、動画の作成を開始します。動画の作成(主にエンコード)には非常に時間がかかります。

作成された動画はカレントディレクトリ内の `all-sailor-moon-memories.mkv` として保存されます。作成された動画の構成は、Matroska Video + H.264 + FLAC(3トラック)です。詳細は MediaInfo の[出力結果](all-sailor-moon-memories.mkv.mediainfo.txt)を参照してください。
