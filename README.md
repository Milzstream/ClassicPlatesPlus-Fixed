<a href="https://discord.gg/Hj49J2APGZ" target="_blank"><img width="50" alt="Join my discord" src="https://user-images.githubusercontent.com/82573908/185756670-b92eaf9e-f4fb-4f8a-b0b0-6325e6a16886.png"></a>

# **ClassicPlates Plus**
ClassicPlates Plus is a nameplates addon that adds additional features and new updated Classic-themed visuals.

## About this fork (Classic Era compatibility)

This fork contains compatibility fixes for **Classic Era 1.15.9+** and is tested on Era Hardcore realms. It targets the Classic Era version of the game.

Fixes included:
- Uses `C_NamePlate.SetNamePlateSize` on modern clients (era 1.15.9+), falling back to the legacy per-type sizing on older clients.
- Hooks the nameplate driver's option update (`ApplyFrameOptions` where present, `UpdateNamePlateOptions` on modern clients) so nameplate resizing still fires.
- Reads the nameplate unit token from the modern `unitToken` field, falling back to the legacy `namePlateUnitToken`.
- Guards against protected/forbidden nameplate frame calls.
- Fixes a negative-height typo that prevented debuff/buff icons (and their cooldowns) from rendering.

These are compatibility guards plus a general bug fix, so other Classic flavors using the legacy nameplate engine are unaffected. A PR to the upstream repository is planned so the classic-era fixes benefit everyone.

## Features
- Buffs and Debuffs tracking
- Threat status
- Class colors and Icons
- Personal nameplate
- Power bar (*mana, rage, energy, etc...*)
- NPC Classification (*rare, elite, world boss, etc...*)

<br />

## How to move Personal Nameplate
You can move personal nameplate in Classic Flavors by holding down CTRL and dragging it with Left Mouse Button.

<br />

## Consider supporting this project
You can support this project with [**one time donation**](https://boosty.to/reubin/donate) or a [**subscription**](https://boosty.to/reubin)

<br />

## Download

- Grab the original on [**CurseForge**](https://www.curseforge.com/wow/addons/classicplatesplus).
- For the latest Classic Era fixes, grab a build from [**GitHub Releases**](https://github.com/Milzstream/ClassicPlatesPlus-Fixed/releases).

<br />

## Screenshots

<br />

![pic8](https://github.com/ReubinAuthor/ClassicPlatesPlus/assets/82573908/816b44ea-b508-45c4-8c27-fe5a67f2a709)

<br />

![pic3](https://github.com/ReubinAuthor/ClassicPlates-Plus/assets/82573908/ac3ec5b3-476f-4fe4-ac33-4edf69cdcf05)

<br />

![pic6](https://github.com/ReubinAuthor/ClassicPlatesPlus/assets/82573908/878a5ee9-83be-47d2-8eea-e3efd84b1e9d)

<br />

![pic7](https://github.com/ReubinAuthor/ClassicPlatesPlus/assets/82573908/f36fe40d-330a-4b47-9abc-d0524227074d)

<br />

![pic1](https://github.com/ReubinAuthor/ClassicPlates-Plus/assets/82573908/9e5945fd-3baf-41b4-b2db-471c783db571)

<br />

![pic4](https://github.com/ReubinAuthor/ClassicPlatesPlus/assets/82573908/a0d98a1d-8753-485d-bf11-995113018a9b)

<br />

![pic5](https://github.com/ReubinAuthor/ClassicPlatesPlus/assets/82573908/9708f849-2341-4b76-a5dc-91c614187b85)

<br />

![pic2](https://github.com/ReubinAuthor/ClassicPlates-Plus/assets/82573908/ed349986-b991-405b-8260-6fbbe205db5b)
