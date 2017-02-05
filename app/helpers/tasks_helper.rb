module TasksHelper
  def project_names(user)
    user.projects.map(&:name).to_json
  end
end
