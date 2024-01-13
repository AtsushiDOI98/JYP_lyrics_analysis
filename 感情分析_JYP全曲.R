install.packages("syuzhet")
install.packages("ggplot2")
install.packages("dplyr")

library(syuzhet)
library(ggplot2)
library(dplyr)

# CSVファイルの読み込み
lyrics_data <- read.csv("jyp_lyrics_cleaned.csv")

# 感情分析の実行
lyrics_data$sentiment_score <- sapply(lyrics_data$歌詞, function(lyric) get_sentiment(lyric, method="syuzhet"))

# グローバルテーマの設定
theme_set(theme_bw(base_family = "HiraKakuProN-W3"))

# 感情スコアのプロット
ggplot(lyrics_data, aes(x=曲名, y=sentiment_score, color=歌手)) + 
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 3.5)) +
  labs(title="各曲の感情スコア", x="曲名", y="感情スコア")
  coord_cartesian(xlim = c(NA, NA), expand = 0.1) # x軸の範囲を拡張

