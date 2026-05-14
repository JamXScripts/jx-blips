# jx-blips

Permanent blip management system for FiveM, powered by [ox_lib](https://github.com/overextended/ox_lib).  
Open the menu with `/createblips`. Create, edit, teleport to, or delete map blips — all saved automatically to a JSON file and restored on every server restart.  
Supports **categories**, **minimap visibility toggle**, and **Discord webhook logs**.  
Access is restricted to players with the ACE permission `jx-blips.admin`.

## Installation

- Make sure `ox_lib` is installed and started **before** `jx-blips` in your `server.cfg`.
- Copy the `jx-blips` folder into your server's `resources` directory.
- Add `ensure jx-blips` to your `server.cfg`.
- Grant admin access via ACE permissions:
  ```
  add_ace group.admin jx-blips.admin allow
  ```

## Configuration

All settings are in `config.lua`:

- `Config.Locale` — `'fr'` (French) or `'en'` (English). Default: `'fr'`.
- `Config.AdminOnly` — `true` to restrict the menu to ACE `jx-blips.admin`, `false` for everyone. Default: `true`.
- `Config.Debug` — `true` to enable debug prints in the console. Default: `false`.
- `Config.DiscordWebhook` — Paste your Discord webhook URL here to enable logs. Leave empty to disable.
- `Config.DefaultSprite` — Default blip sprite ID. Default: `1`.
- `Config.DefaultColor` — Default blip color ID. Default: `2`.
- `Config.DefaultScale` — Default blip scale. Default: `0.8`.
- `Config.DefaultAlwaysVisible` — `true` = always visible on minimap, `false` = short range only. Default: `true`.
- `Config.BlipCategories` — List of blip categories. Each entry uses a locale key for its label, so the name adapts automatically to the configured language.

## Compatibility

- Standalone — no game framework required (QBCore, ESX, QBox, etc.).

Requires [ox_lib](https://github.com/overextended/ox_lib) for the UI (menus, notifications).  
No other dependency needed.

## Credits

- [ox_lib](https://github.com/overextended/ox_lib) by **Overextended** — used for menus, notifications and dialogs.

*Fait par un Québécois ⚜️ avec ❤️*  
— JamX

## License

This project is licensed under the GNU General Public License v3.0.  
You can find the full license text in the [LICENSE](LICENSE) file.

## Community

Got a question, an idea, or just want to hang out?  
Join the **JamX Scripts** Discord: https://discord.gg/xqP5GXupUT

- `#FR-français`
- `#EN-english`

*The server is brand new — thanks for your patience while we build it!*