module TasksHelper
  def project_names(user)
    user.projects.where.not( name: '' ).all.map(&:name).to_json
  end
end
