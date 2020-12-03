module FFXIVCollectBot::Commands
  module Collectables
    extend Discordrb::Commands::CommandContainer

    BASE_URL = 'https://ffxivcollect.com'.freeze
    API_URL  = 'https://ffxivcollect.com/api'.freeze

    %w(achievement title mount minion orchestrion emote barding hairstyle armoire spell fashion).each do |type|
      command(type.to_sym) do |event, *message|
        name = message.join(' ')
        endpoint = "#{type}s"
        url = search_url(endpoint, name)

        begin
          response = JSON.parse(RestClient.get(url), symbolize_names: true)
          results = response[:results].sort_by { |collectable| collectable[:name].size }
          collectable = results.first

          if collectable
            event.channel.send_embed do |embed|
              embed.colour = 0xdaa556

              if type == 'spell'
                embed.description = collectable[:tooltip].gsub(/(?<=\n)(.*?):/, '**\1:**')
              elsif type == 'title'
                embed.description = collectable.dig(:achievement, :description)
              else
                embed.description = collectable[:enhanced_description] || collectable[:description]
              end

              embed.image = Discordrb::Webhooks::EmbedImage.new(url: collectable[:image])
              embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: collectable[:icon])
              embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: collectable[:name],
                                                                  url: collectable_url(endpoint, collectable[:id]))

              if response[:count] > 1
                embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: additional_results(results))
              end

              if type == 'spell'
                embed.add_field(name: 'Type', value: collectable.dig(:type, :name), inline: true)
                embed.add_field(name: 'Aspect', value: collectable.dig(:aspect, :name), inline: true)
              else
                embed.add_field(name: 'Owned', value: collectable[:owned], inline: true)
              end

              embed.add_field(name: 'Patch', value: collectable[:patch], inline: true)

              if collectable[:sources]
                embed.add_field(name: 'Source', value: format_sources(collectable))
              end
            end
          else
            event.message.respond("#{type.capitalize} not found.")
          end
        rescue Discordrb::Errors::NoPermission
          event.message.respond("Sorry, I need the **Embed Links** permission to do that.")
        rescue RestClient::ExceptionWithResponse
          event.message.respond('Sorry, there was a problem reaching the FFXIV Collect API.')
          raise
        rescue
          event.message.respond('Sorry, something broke. :frowning:')
          raise
        end
      end
    end

    class << self
      def search_url(endpoint, name)
        "#{API_URL}/#{endpoint}?name_en_cont=#{name}"
      end

      def collectable_url(endpoint, id)
        "#{BASE_URL}/#{endpoint}/#{id}"
      end

      def format_sources(collectable)
        collectable[:sources].map { |source| source[:text] }.join("\n")
      end

      def additional_results(results)
        names = results[1..10].map { |collectable| collectable[:name] }
        names << '...' if results.size > 11
        "Also available: #{names.join(', ')}"
      end
    end
  end
end
