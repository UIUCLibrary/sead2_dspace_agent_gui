SEAD2_AGENT_CONFIG = YAML.load_file(File.join(Rails.root, 'config', 'sead2_agent.yml'))[Rails.env]
SERVICES_CONFIG = YAML.load_file(File.join(Rails.root, 'config', 'services.yml'))[Rails.env]