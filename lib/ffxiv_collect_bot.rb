require 'ostruct'
require 'yaml'

Bundler.require(:default)

module FFXIVCollectBot
  CONFIG = OpenStruct.new(YAML.load_file('config/config.yml'))

  Dir['lib/ffxiv_collect_bot/*.rb'].sort.each { |file| load file }

  bot = Discordrb::Commands::CommandBot.new(token: CONFIG.token, client_id: CONFIG.client_id, prefix: CONFIG.prefix,
                                            intents: nil, help_command: false, log_mode: :quiet)

  %w(commands).each do |path|
    new_module = Module.new
    const_set(path.capitalize.to_sym, new_module)
    Dir["lib/ffxiv_collect_bot/#{path}/*.rb"].sort.each { |file| load file }

    new_module.constants.each do |mod|
      bot.include!(new_module.const_get(mod))
    end
  end

  bot.run
end
