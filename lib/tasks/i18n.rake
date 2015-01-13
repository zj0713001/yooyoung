namespace :i18n do
  desc '根据名称生成.zh-CN.yml'

  def default_translate
    @default_translation ||= {
      'id' => 'ID',
      'active' => '有效？',
      'published' => '已发布？',
      'published_at' => '发布时间',
      'unpublished_at' => '取消发布时间',
      'created_at' => '创建时间',
      'updated_at' => '修改时间',
      'editor_id' => '编辑',
      'deleted_at' => '删除时间',
      'sequence' => '排序',
      'description' => '描述',
      'tips' => 'Tips',
    }
  end

  def except_columns
    @except_columns ||= %w[
      lock_version
    ]
  end

  task generate: :environment do
    model = ENV['MODEL'].to_s.camelize.safe_constantize
    yml_options = {
      'zh-CN' => {
        'activerecord' => {
          'models' => {
            ENV['MODEL'].to_s => ''
          },
          'attributes' => {
            ENV['MODEL'].to_s => (model.columns.map(&:name) - except_columns).map do |column|
              translate = default_translate[column]
              { column => translate}
            end.inject(&:merge)
          }
        }
      }
    }
    yaml_file = File.open(File.join(Rails.root, 'config', 'locales', 'models', "#{ENV['MODEL'].to_s}.zh-CN.yml"), 'w')
    yaml_file.write yml_options.to_yaml
    yaml_file.close
  end
end
