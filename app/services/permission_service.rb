class PermissionService
  include Singleton

  def initialization
    Permission::RESOURCES.each do |resource|
  %w[index show create update destroy publish].each do |action|
    Permission.where(action: action, resource: resource).first_or_create(name: m[:title])
  end
end if Permission.table_exists?
  end
end
