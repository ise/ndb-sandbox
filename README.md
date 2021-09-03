[NDBオープンデータ](https://www.mhlw.go.jp/stf/seisakunitsuite/bunya/0000177182.html) をさわるためのリポジトリです。

# 手順

## DBを立ち上げて、NDBのデータをDBにインポートする手順

```sh

# 準備
# dockerをインストールしておく

# DB起動
docker compose up

# NDBのデータをインポートする
cd scripts
docker compose run --rm ruby bundle exec ridgepole -c 'mysql2://root:password@mariadb:3306/ndb_sandbox' -f ./db/Schemafile --apply
docker compose run --rm ruby bundle exec ridgepole -c ./db/config.yml -f ./db/Schemafile --apply
docker compose run --rm ruby bundle exec ruby app/import_csv.rb

# その後
# phpmyadminとかredashとかで接続してなにかをする

```

## csvファイルを再作成する手順

```sh

cd scripts
docker compose run --rm ruby bundle exec ruby app/to_csv.rb

# sources/以下にcsvファイルができる
# エラー出た場合は想定してるファイルフォーマットじゃない可能性があるのでto_csv.rbを修正すること

```

# sources以下について

## 第６回NDBオープンデータ

### 歯科傷病

| filenmae | desc |
| --- | --- |
| 000821581.xlsx | 性年齢別　傷病件数 |

### 歯科診療行為

| filenmae | desc |
| --- | --- |
| 000821521.xlsx | A基本診療料 初再診料_性年齢別算定回数 |
| 000821529.xlsx | B医学管理等 性年齢別算定回数 |
| 000821532.xlsx | C在宅医療 性年齢別算定回数 |
| 000821535.xlsx | D検査 性年齢別算定回数 |
| 000821539.xlsx | E画像診断 性年齢別算定回数 |
| 000821542.xlsx | F投薬 性年齢別算定回数 |
| 000821545.xlsx | G注射 性年齢別算定回数 |
| 000821549.xlsx | Hリハビリテーション 性年齢別算定回数／単位数 |
| 000821552.xlsx | I処置 性年齢別算定回数 |
| 000821555.xlsx | J手術 性年齢別算定回数 |
| 000821558.xlsx | J輸血料 性年齢別算定回数 |
| 000821564.xlsx | K麻酔 性年齢別算定回数 |
| 000821567.xlsx | L放射線治療 性年齢別算定回数 |
| 000821570.xlsx | M歯冠修復及び欠損補綴 性年齢別算定回数 |
| 000821573.xlsx | N歯科矯正 性年齢別算定回数 |
| 000821576.xlsx | O病理診断 性年齢別算定回数 |
