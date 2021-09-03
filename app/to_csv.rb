require "csv"
require "rubyXL"

class ToCsv
  BASE_PATH = "."

  def initialize
  end

  def perform
    disease
    practice
  end

  # 歯科傷病
  def disease
    puts "歯科傷病のcsvファイルを作成開始"

    source = "#{BASE_PATH}/sources/第６回NDBオープンデータ/歯科傷病/000821581.xlsx"
    puts "#{source}を読み込み"
    workbook = RubyXL::Parser.parse(source)
    dest = "#{BASE_PATH}/sources/第６回NDBオープンデータ/歯科傷病/#{File.basename(source, ".xlsx")}.csv"
    puts "#{dest}を作成"
    CSV.open(dest, "wb") do |csv|
      size = workbook.worksheets[0].sheet_data.size
      for index in 4..size
        row = workbook.worksheets[0].sheet_data[index]
        next if row.nil?

        # 傷病グループ
        disease_group = row[0].value if row[0]&.value
        csv << [disease_group, row[1..42].map(&:value)].flatten
      end
    end

    puts "歯科傷病のcsvファイルを作成完了"
  end

  # 歯科診療行為
  def practice
    puts "歯科診療行為のcsvファイルを作成開始"

    dir = "#{BASE_PATH}/sources/第６回NDBオープンデータ/歯科診療行為"
    Dir.glob("#{dir}/*.xlsx").each do |file|
      practice_file(dir, file)
    end

    puts "歯科診療行為のcsvファイルを作成完了"
  end

  def practice_file(dir, source)
    puts "#{source}を読み込み"
    workbook = RubyXL::Parser.parse(source)
    dest = "#{dir}/#{File.basename(source, ".xlsx")}.csv"
    puts "#{dest}を作成"
    CSV.open(dest, "wb") do |csv|
      size = workbook.worksheets[0].sheet_data.size
      for index in 4..size
        row = workbook.worksheets[0].sheet_data[index]
        next if row.nil?

        # 分類コード
        category_code = row[0].value if row[0]&.value
        # 区分名称
        classification_name = row[1].value if row[1]&.value
        csv << [category_code, classification_name, row[2..43].map(&:value)].flatten
      end
    end
  end
end

ToCsv.new.perform

__END__

## 歯科傷病excelファイルのヘッダ

0: 傷病グループ
1: 傷病コード
2: 傷病名
3: 総計
4-22: 男性 0～4歳,5～ 9歳,10～14歳,15～19歳,20～24歳,25～29歳,30～34歳,35～39歳,40～44歳,45～49歳,50～54歳,55～59歳,60～64歳,65～69歳,70～74歳,75～79歳,80～84歳,85～89歳,90歳以上
23-41: 女性 0～4歳, 5～ 9歳,10～14歳,15～19歳,20～24歳,25～29歳,30～34歳,35～39歳,40～44歳,45～49歳,50～54歳,55～59歳,60～64歳,65～69歳,70～74歳,75～79歳,80～84歳,85～89歳,90歳以上

## 歯科診療行為excelファイルのヘッダ

0: 分類コード
1: 区分名称
2: 診療行為コード
3: 診療行為
4: 点数
5: 総計
6-24: 男性 0～4歳,5～ 9歳,10～14歳,15～19歳,20～24歳,25～29歳,30～34歳,35～39歳,40～44歳,45～49歳,50～54歳,55～59歳,60～64歳,65～69歳,70～74歳,75～79歳,80～84歳,85～89歳,90歳以上
25-43: 女性 0～4歳, 5～ 9歳,10～14歳,15～19歳,20～24歳,25～29歳,30～34歳,35～39歳,40～44歳,45～49歳,50～54歳,55～59歳,60～64歳,65～69歳,70～74歳,75～79歳,80～84歳,85～89歳,90歳以上
