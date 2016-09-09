module ApplicationHelper
  def to_hankaku(str)
    str.tr('Ａ-Ｚａ-ｚ','A-Za-z')
  end
end
