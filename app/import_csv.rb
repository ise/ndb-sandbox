require "csv"
require "sequel"
require "yaml"

class ImportCsv
  BASE_PATH = "."
  MAX_AGE = 999
  AGE_STEP = 5

  def initialize
    config = YAML.load_file("#{BASE_PATH}/db/config.yml")
    @db = Sequel.connect(config)
  end

  def perform
    import_disease
    import_practice
  ensure
    @db.disconnect # いらんか
  end

  def import_disease
    puts "歯科傷病のインポート開始"
    dental_disease_counts = @db[:dental_disease_counts]
    source = "#{BASE_PATH}/sources/第６回NDBオープンデータ/歯科傷病/000821581.csv"
    puts "#{source}を読み込み"
    CSV.foreach(source, encoding: "UTF-8:UTF-8") do |row|
      # 総計
      dental_disease_counts.insert(
        disease_group: row[0],
        code: row[1],
        name: row[2],
        sex: nil,
        age_upper: nil,
        age_lower: nil,
        count: normalize_count(row[3]),
        is_total: true
      )
      # 男性
      row[4..22].each_with_index do |c, i|
        range = age_range(i)
        rec = {
          disease_group: row[0],
          code: row[1],
          name: row[2],
          sex: "male",
          age_upper: range[:upper],
          age_lower: range[:lower],
          count: normalize_count(c),
          is_total: false
        }
        dental_disease_counts.insert(rec)
      end

      # 女性
      row[23..41].each_with_index do |c, i|
        range = age_range(i)
        rec = {
          disease_group: row[0],
          code: row[1],
          name: row[2],
          sex: "female",
          age_upper: range[:upper],
          age_lower: range[:lower],
          count: normalize_count(c),
          is_total: false
        }
        dental_disease_counts.insert(rec)
      end
    end
    puts "歯科傷病のインポート完了"
  end

  def import_practice
    puts "歯科診療行為のインポート開始"
    dir = "#{BASE_PATH}/sources/第６回NDBオープンデータ/歯科診療行為"
    Dir.glob("#{dir}/*.csv").each do |file|
      import_practice_file(file)
    end
    puts "歯科診療行為のインポート完了"
  end

  def import_practice_file(source)
    dental_practice_counts = @db[:dental_practice_counts]
    puts "#{source}を読み込み"
    CSV.foreach(source, encoding: "UTF-8:UTF-8") do |row|
      # 総計
      dental_practice_counts.insert(
        category_code: row[0],
        classification_name: row[1],
        code: row[2],
        name: row[3],
        score: normalize_count(row[4]),
        sex: nil,
        age_upper: nil,
        age_lower: nil,
        count: normalize_count(row[5]),
        is_total: true
      )
      # 男性
      row[6..24].each_with_index do |c, i|
        range = age_range(i)
        rec = {
          category_code: row[0],
          classification_name: row[1],
          code: row[2],
          name: row[3],
          score: normalize_count(row[4]),
          sex: "male",
          age_upper: range[:upper],
          age_lower: range[:lower],
          count: normalize_count(c),
          is_total: false
        }
        dental_practice_counts.insert(rec)
      end

      # 女性
      row[25..43].each_with_index do |c, i|
        range = age_range(i)
        rec = {
          category_code: row[0],
          classification_name: row[1],
          code: row[2],
          name: row[3],
          score: normalize_count(row[4]),
          sex: "female",
          age_upper: range[:upper],
          age_lower: range[:lower],
          count: normalize_count(c),
          is_total: false
        }
        dental_practice_counts.insert(rec)
      end
    end
  end

  def normalize_count(count)
    count == "-" ? 0 : count.to_i
  end

  # 下記のような年代の上限下限を返す
  # 0～4歳,5～ 9歳,10～14歳,15～19歳,20～24歳,25～29歳,30～34歳,35～39歳,40～44歳,45～49歳,50～54歳,55～59歳,60～64歳,65～69歳,70～74歳,75～79歳,80～84歳,85～89歳,90歳以上
  def age_range(index)
    lower = index * AGE_STEP
    {
      upper: index == 18 ? MAX_AGE : lower + AGE_STEP - 1,
      lower: lower
    }
  end
end

ImportCsv.new.perform
