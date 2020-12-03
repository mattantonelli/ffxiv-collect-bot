# FFXIV Collect Bot

This is a Discord bot designed for the [API](https://github.com/mattantonelli/ffxiv-collect/wiki) provided by my Final Fantasy XIV collectable tracking site [FFXIV Collect](https://ffxivcollect.com/). Powered by [discordrb](https://github.com/shardlab/discordrb).

## Installation

This is currently a private bot. You will need to create and run your own Discord app to add it to your server.

1. [Create a new Discord app](https://discordapp.com/developers/applications/me)
2. Create a bot user
3. Insert your client ID into the following URL: `https://discord.com/oauth2/authorize?&client_id=INSERT_CLIENT_ID_HERE&permissions=18432&scope=bot`
4. Follow the URL to add the bot to your server (requires the Manage Server permission)
5. `git clone https://github.com/mattantonelli/ffxiv-collect-bot`
6. `cd ffxiv-collect-bot`
7. `bundle install`
8. Set up the configuration file
    * `cp config/config.yml.example config/config.yml`
9. `bundle exec ruby run.rb`

## Permissions

FFXIV Collect Bot requires the following permissions:

* Send Messages
* Embed Links

## Commands
### Collectable Search

Search any of the collections provided by the API by their English name. Collectable search is available through the following commands:

* achievement
* title
* mount
* minion
* orchestrion
* emote
* barding
* hairstyle
* armoire
* spell
* fashion

#### Usage
```
!collection name
```

#### Example
```
!mount shadow gwiber
```

---

FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.

FINAL FANTASY XIV © SQUARE ENIX CO., LTD.
