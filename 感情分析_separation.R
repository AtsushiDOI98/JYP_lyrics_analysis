library(syuzhet)
library(ggplot2)
library(dplyr)

# CSVファイルの読み込み（UTF-8エンコーディングを指定）
lyrics_data <- read.csv("jyp_lyrics_cleaned.csv", fileEncoding = "UTF-8")

# 各歌手の全曲に対して感情分析を実行
lyrics_data <- lyrics_data %>%
  group_by(歌手) %>%
  mutate(sentiment_score = sapply(歌詞, function(lyric) get_sentiment(lyric, method="syuzhet")))

# 感情スコアが0以上または0以下の曲を分類
positive_songs <- filter(lyrics_data, sentiment_score >= 0)
negative_songs <- filter(lyrics_data, sentiment_score < 0)

# CSVファイルとして保存
write.csv(positive_songs, "positive_songs.csv", row.names = FALSE)
write.csv(negative_songs, "negative_songs.csv", row.names = FALSE)

# グローバルテーマの設定
theme_set(theme_bw(base_family = "HiraKakuProN-W3"))

# 感情スコアのプロットに0のラインを追加
ggplot(lyrics_data, aes(x=曲名, y=sentiment_score, color=歌手)) + 
  geom_point() +
  geom_hline(yintercept = 0, linetype="solid", color = "black") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 4.5)) +
  facet_wrap(~ 歌手, scales = "free_x") +
  labs(title="各歌手の全曲の感情スコア", x="曲名", y="感情スコア") +
  coord_cartesian(xlim = c(NA, NA), expand = 0.1)
