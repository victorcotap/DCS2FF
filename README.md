# DCS2FF
An simple Export.lua script to connect between DCS and ForeFlight, Garmin Pilot, etc...

## Features
- Shows current position
- AHRS is supported and will give you synthetic vision in your app of choice
- Traffic is reported as ADS-B traffic

## Installation
- Drop the file in your `Saved Games/DCS.openbeta/Scripts` folder (right next to Export.lua)
- Edit the line at the top of the TOP-DCS2FF.lua and replace the `broadcastIP` by yours and change the last number for `255`
- Add this following line to `Export.lua`:
`local DCS2FFlfs=require('lfs');dofile(DCS2FFlfs.writedir()..'Scripts/TOP-DCS2FF.lua')`

## Usage
- Just start your EFB of choice and either add a device 
- Foreflight will just simply recognize the new device without any input
- Make sure to turn on traffic
