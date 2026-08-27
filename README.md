# ElvUI TukUI

A Retail-only ElvUI plugin that applies a TukUI-style gameplay HUD while leaving ElvUI responsible for frame logic, Blizzard API compatibility, and Blizzard window skins.

## Goal

Keep the parts of TukUI that define the in-game HUD:

- left/right chat panels
- bottom data-panel feel
- compact action bars
- player/target frames
- class resources and cast bars
- minimap
- nameplates
- dark TukUI fonts/borders/panels

Character, Spellbook, Talents, Bags, Merchant, Quest Log, Auction House and other Blizzard windows remain normal ElvUI.

## Requirements

- World of Warcraft Retail
- ElvUI

## Install

Place `ElvUI_Tukui` beside `ElvUI` in `Interface/AddOns/`, reload, and run:

`/tukuiinstall`

Choose either **4K Desktop** or **1600p Laptop**.

You can reapply directly with:

- `/tukuiapply` — 4K Desktop
- `/tukuiapply laptop` — 1600p Laptop

Then `/reload`.

## Architecture

This addon writes normal ElvUI profile values and mover positions. It does not replace ElvUI unit frames, action bars, nameplates, chat frames, oUF, or Blizzard skins.
