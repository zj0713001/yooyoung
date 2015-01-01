# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 初始化权限
Permission::RESOURCES.each do |resource|
  Permission::ACTIONS.each do |action|
    Permission.find_or_create_by(resource: resource, action: action) do |permission|
      permission.name = "#{I18n.t("permissions.resources.#{resource}")}-#{I18n.t("permissions.actions.#{action}")}"
    end
  end
end if Permission.table_exists?

# 初始化用户角色
Role.find_or_create_by(name: '用户') do |role|
  role.space = :main
  role.permissions = Permission.none
end

# 初始化管理员角色
Role.find_or_create_by(name: '管理员') do |role|
  role.space = :admin
  role.permissions = Permission.all
end
