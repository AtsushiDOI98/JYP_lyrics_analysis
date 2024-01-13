library(syuzhet)
library(ggplot2)
library(dplyr)

# CSVファイルの読み込み
lyrics_data <- read.csv("jyp_lyrics_cleaned.csv")

# 各歌手ごとに感情分析を実行
lyrics_data_grouped <- lyrics_data %>%
  group_by(歌手) %>%
  mutate(sentiment_score = sapply(歌詞, function(lyric) get_sentiment(lyric, method="syuzhet"))) %>%
  summarise(average_sentiment = mean(sentiment_score, na.rm = TRUE))

# 平均感情スコアのプロット
ggplot(lyrics_data_grouped, aes(x=歌手, y=average_sentiment, fill=歌手)) + 
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme_set( theme_bw(base_family = "HiraKakuProN-W3"))
  labs(title="各歌手の平均感情スコア", x="歌手", y="平均感情スコア")
