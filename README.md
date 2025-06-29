<!-- Document: README.md

All Sailor Moon Memoriesのマニュアル。

Metadata:

  id - 4d5beda3-572f-471f-8c96-67e994c385b9
  author - <qq542vev at https://purl.org/meta/me/>
  version - 1.0.4
  created - 2023-04-09
  modified - 2025-06-29
  copyright - Copyright (C) 2023-2025 qq542vev. Some rights reserved.
  license - <CC-BY-4.0 at https://creativecommons.org/licenses/by/4.0/>
  conforms-to - <https://spec.commonmark.org/current/>

See Also:

  * <Project homepage at https://github.com/qq542vev/all-sailor-moon-memories>
  * <Bag report at https://github.com/qq542vev/all-sailor-moon-memories/issues>
-->

# All Sailor Moon Memories

[All Sailor Moon Memories](https://www.youtube.com/watch?v=mjNPCGO-ey0)はSailor Moon Memoriesの各動画を一覧表示した動画を作成する試みです。Sailor Moon Memoriesは[fabzt10](https://www.youtube.com/channel/UCi30Verb3Spu3oQiKnlmsqg)さんによって作成された、セーラームーンを題材にした幾つかのAMV(Anime Music Video)です。

現状では以下の3つの動画を分割して一覧表示します。

 * 左上 - [sailor moon memories opening 2nd version セーラームーン](https://www.youtube.com/watch?v=cBRYceV7b1Q)
 * 右上 - [Opening sailor moon MemorieS](https://www.youtube.com/watch?v=hj_xSv0F76Q)
 * 左下 - [sailor moon memories opening](https://www.youtube.com/watch?v=coShQEyM0ic)

# 動画を作成する

動画を作成するにはご使用のコンピューターに[yt-dlp](https://github.com/yt-dlp/yt-dlp)と[FFmpeg](https://ffmpeg.org/)がインストールされている必要があります。可能な限り最新版を使用してください。2025年06月26日現在、yt-dlpは[2025.06.25](https://github.com/yt-dlp/yt-dlp/releases/tag/2025.06.25)、FFmpegは[7.1.1-1+b1](https://ffmpeg.org/download.html)での組み合わせで動作することを確認しています。

[`makefile`](makefile)をダウンロードして、実行してください。YouTubeから動画をダウンロードします。ダウンロードされた動画はカレントディレクトリの`./vidoes`内に保存されます。その後、動画の作成を開始します。動画の作成(主にエンコード)には非常に時間がかかります。

作成された動画はカレントディレクトリ内に`all-sailor-moon-memories.mkv`として保存されます。作成された動画の構成は、Matroska Video + H.264 + 音声(3トラック)です。詳細はMediaInfoの[出力結果](all-sailor-moon-memories.txt)を参照してください。
