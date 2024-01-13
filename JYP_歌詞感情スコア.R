library(syuzhet)
library(ggplot2)
library(dplyr)

# CSVファイルの読み込み（UTF-8エンコーディングを指定）
lyrics_data <- read.csv("jyp_lyrics_cleaned.csv", fileEncoding = "UTF-8")

# 各歌手の全曲に対して感情分析を実行
lyrics_data <- lyrics_data %>%
  group_by(歌手) %>%
  mutate(sentiment_score = sapply(歌詞, function(lyric) get_sentiment(lyric, method="syuzhet")))

# グローバルテーマの設定
theme_set(theme_bw(base_family = "HiraKakuProN-W3"))

# 感情スコアのプロット
ggplot(lyrics_data, aes(x=曲名, y=sentiment_score, color=歌手)) + 
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 4.5)) + # テキストサイズを小さくする
  facet_wrap(~ 歌手, scales = "free_x") +
  labs(title="各歌手の全曲の感情スコア", x="曲名", y="感情スコア") +
  coord_cartesian(xlim = c(NA, NA), expand = 0.1) # x軸の範囲を拡張


# 感情スコア付きのデータをCSVファイルとして保存
write.csv(lyrics_data, "JYP_歌詞感情スコア.csv", row.names = FALSE, fileEncoding = "UTF-8")
