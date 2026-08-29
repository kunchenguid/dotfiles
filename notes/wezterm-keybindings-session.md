# WezTerm-tangentbord: sessionsstatus (2026-08-28)

Anteckning för att en ny (moln-)session ska kunna fortsätta där denna slutade.
Miljö: macOS, WezTerm 20240203-110809-5046fc22, tangentbordslayout "Swedish - Pro".
Config: `home/.config/wezterm/wezterm.lua`.

## Vad som gjordes idag

1. **Ny bindning `CMD+SHIFT+M`**: slår ihop den föregående (vänstra) fliken med
   den aktiva som en pane-split i samma flik, via
   `wezterm cli split-pane --pane-id <aktiv> --move-pane-id <andra> --horizontal`
   (`--move-pane-id` finns i denna wezterm-version, verifierat med
   `wezterm cli split-pane --help` och manuellt testat direkt via CLI - fungerar).
   - Lua-callbacken använder `window:mux_window():tabs_with_info()` och
     `tab:panes_with_info()` för att hitta föregående flikens aktiva pane-id.
   - Ursprunglig version letade fel håll (nästa flik istället för föregående) och
     misslyckades tyst på sista fliken - rättat.
   - Visar nu en `toast_notification` om det inte finns någon flik att slå ihop med.
   - **Status: bekräftat fungerande** ("Nu verkar det funka").

2. **Buggfix i en redan existerande bindning `CMD+SHIFT+C`** (helkopiering av
   scrollback): `wezterm.action.CopyMode({ CopyTo = ... })` är fel syntax -
   `CopyTo` är en egen toppnivå-action, inte en `CopyModeAssignment`-variant.
   Orsakade ett fatalt config-laddningsfel (traceback i loggen). Rättat till
   `wezterm.action.CopyTo("Clipboard")` (användaren ändrade sedan värdet själv
   från `"ClipboardAndPrimarySelection"` till `"Clipboard"`).

## Olöst: reload-tangenterna (CMD+R / CTRL+SHIFT+R / CMD+SHIFT+R) verkar inte fungera

Användaren rapporterar att ingen av dessa reagerar:
- `CMD+SHIFT+R` - **är aldrig bunden till reload som standard** i WezTerm
  (min ursprungliga instruktion om detta var fel).
- `CTRL+SHIFT+R` - default-bindning till `ReloadConfiguration`, borde fungera.
- `CMD+R` (`SUPER+r`) - default-bindning till `ReloadConfiguration`, borde fungera.

### Redan uteslutet
- **Config-filen själv**: `wezterm show-keys --lua` visar att alla tre riktiga
  bindningarna (`CTRL+R`, `SHIFT|CTRL+R`, `SUPER+r`) är korrekt registrerade mot
  `ReloadConfiguration`, inga konflikterande overrides tidigare i listan.
- **Allmän interception av CTRL+SHIFT-kombon**: `CTRL+SHIFT+L` (debug overlay,
  `ShowDebugOverlay`) fungerar och visas synligt - alltså tar WezTerm emot
  CTRL+SHIFT-kombinationer generellt. Problemet är specifikt kopplat till
  R-tangenten, inte till modifierartangenterna.
- **Kända remapping-verktyg**: inga processer för Karabiner-Elements,
  Hammerspoon, BetterTouchTool, Rectangle, Alfred, Raycast, skhd hittades
  körande (`ps aux`).
- **`hidutil` key remapping**: `hidutil property --get "UserKeyMapping"` -> null.
- **macOS systemgenvägar** (`defaults read com.apple.symbolichotkeys
  AppleSymbolicHotKeys`): ingen post med `keyCode == 15` (R-tangentens
  Carbon-keycode) hittades bland aktiva genvägar.
- **OpenSuperWhisper** (körande bakgrundsapp, diktering/Whisper-transkribering):
  `~/Library/Preferences/ru.starmel.OpenSuperWhisper.plist` visar
  `KeyboardShortcuts_toggleRecord` = Option + \` (grave-tangenten,
  carbonKeyCode 50, carbonModifiers 2048=Option) och `modifierOnlyHotkey` =
  `"rightOption"` (tryck/släpp höger Option ensam). Användaren bekräftade att
  det är höger Option de faktiskt använder för att starta inspelning - inte R.
  **Definitivt uteslutet.**
- **ChatGPT-skrivbordsappen** (körande, `com.openai.chat.plist`):
  `toggleLauncher` = Option+Space, `toggleAttachedLauncher` = Option+Shift+1,
  `openSettings` = Cmd+`,`. Ingen R-bindning. Sannolikt inte boven, men inte
  testat genom att faktiskt stänga appen och pröva om.

### Inte testat än / nästa steg
- **Stäng övriga körande appar en i taget och testa `CMD+R` mellan varje**:
  NordVPN, Spotify, WhatsApp, Mail, Messages, Notes, Passwords, Safari,
  Activity Monitor, TextEdit, Tips, System Settings. (Fullständig lista över
  körande GUI-appar vid felsökningstillfället, hämtad via
  `osascript -e 'tell application "System Events" to get name of every process
  whose background only is false'`: Safari, ChatGPT, Terminal, Claude, Mail,
  TextEdit, Activity Monitor, Notes, Messages, Passwords, Finder, NordVPN,
  Spotify, WhatsApp, wezterm-gui, System Settings, OpenSuperWhisper, Tips.)
- **Starta om wezterm-gui med utökad loggning** (t.ex. `WEZTERM_LOG=trace`)
  för att se om R-tangenttryckningen ens når WezTerm-processen. Kräver att
  den körande instansen dödas och startas om, vilket stänger alla användarens
  öppna flikar/paneler - måste godkännas av användaren innan det görs.
- Loggfilen för den aktiva processen (`~/.local/share/wezterm/wezterm-gui-log-<pid>.txt`,
  hitta rätt pid via `ps aux | grep wezterm-gui`) visar bara ERROR-nivå som
  standard - lyckade reloads syns inte där, bara Lua-fel.

## Olöst: hur verifiera att en manuell reload faktiskt sker

Föreslagen men ännu inte genomförd test:
1. Sätt temporärt `config.automatically_reload_config = false` i wezterm.lua
   (så att sparning inte redan triggar auto-reload och maskerar resultatet).
2. Ändra något visuellt påtagligt, t.ex. `config.window_background_opacity`
   till `0.3`.
3. Spara filen (inget ska hända ännu).
4. Tryck den tangentkombo som testas (t.ex. `CMD+R`).
5. Om bakgrunden blir mer genomskinlig fungerade den tangenten. Om inte -
   den fastnar fortfarande.
6. Återställ `automatically_reload_config` (ta bort raden, standard är `true`)
   och `window_background_opacity` till `0.8` efteråt.

Användaren har inte bett mig genomföra detta än - fråga om de vill det, eller
om de redan testat manuellt.
