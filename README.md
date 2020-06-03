# AnimateUI
Animated UI Messages for FiveM

## Features
* Smooth entry and exit animations
* Choose from a variety of effects (slide, bounce, fade, typewriter, etc)
* Optional callbacks can be set
* Fine control of position, size, color, etc
* Uses native UI so no need for NUI
* Performant

## Demo
<details>
<summary>Fade</summary>

![Demo Image 1](https://imgur.com/0IedTL1.jpeg)

</details>


## Requirements

* None

## Download & Installation

* Download and extract the package: https://github.com/Mobius1/AnimateUI/archive/master.zip
* Rename the `AnimateUI-master` directory to `AnimateUI`
* Drop the `AnimateUI` directory into your resources directory on your server
* Add `start AnimateUI` in your `server.cfg`
* Edit `config.lua` to your liking
* Start your server and rejoice!

## Usage
The text can be shown by using the `exports.AnimateUI:showMessage` function.
```lua
exports.AnimateUI:showMessage(Text, EntryEffect, Duration, Timeout, ExitEffect, Callback)
```
### `Text` (Required)
The `Text` param is the text you want to show to the player.

### `EntryEffect` (Required)
The `EntryEffect` param is the effect used to show the text to the player.

### `Duration` (Required)
The `Duration` param determines how long the entry effect will be played.

### `Timeout` (Required)
The `Timeout` param determines how long the text is displayed before being removed.

### `ExitEffect` (Optional)
The `ExitEffect` param can either be a string denoting the effect name to be used or a table. If the effect name is used then the duration of the exit effect will be the same as the entry duration (`Duration`). You can define the duration of the exit animation by using a table:
```lua
exports.AnimateUI:showMessage("My Message", "FadeIn", 1000, 3000, "FadeOut")

-- or

exports.AnimateUI:showMessage("My Message", "FadeIn", 1000, 3000, 
{
    Effect = 'FadeOut',   -- the exit effect to use
    Duration = 1000       -- the duration the exit effect
})
```

The `ExitEffect` param is optional and if left empty, the text will just disappear when done.

### `Callback` (Optional)
The `Callback` param is optional, but when used will fire when the text has been hidden:
```lua
exports.AnimateUI:showMessage("My Message", "FadeIn", 1000, 3000, "FadeOut", function()
    -- Do something when the text has been hidden
end)
```

## Available Effects

Entry effects can only be used to show the text and exit effects can only be used to hide the text.

### Entry Effects
#### Fade
* `FadeIn`
* `FadeInUp`
* `FadeInDown`
* `FadeInLeft`
* `FadeInRight`

#### Slide
* `SlideInUp`
* `SlideInDown`
* `SlideInLeft`
* `SlideInRight`

#### Bounce
* `BounceIn`
* `BounceInUp`
* `BounceInDown`
* `BounceInLeft`
* `BounceInRight`

#### Elastic
* `ElasticIn`
* `ElasticInUp`
* `ElasticInDown`
* `ElasticInLeft`
* `ElasticInRight`

#### Zoom
* `ZoomIn`

#### Misc
* `TypewriterIn`


### Exit Effects
#### Fade
* `FadeOut`
* `FadeOutUp`
* `FadeOutDown`
* `FadeOutLeft`
* `FadeOutRight`

#### Slide
* `SlideOutUp`
* `SlideOutDown`
* `SlideOutLeft`
* `SlideOutRight`

#### Bounce
* `BounceOut`
* `BounceOutUp`
* `BounceOutDown`
* `BounceOutLeft`
* `BounceOutRight`

#### Elastic
* `ElasticOut`
* `ElasticOutUp`
* `ElasticOutDown`
* `ElasticOutLeft`
* `ElasticOutRight`

#### Zoom
* `ZoomOut`

#### Misc
* `TypewriterOut`

## Removing Text
If you require the text to be removed at anytime, you can utilise the `exports.AnimateUI:removeMessage` function. To remove the message, you must store the ID beforehand:

```lua
local ID = exports.AnimateUI:showMessage("My Message", "FadeIn", 1000, 3000)

exports.AnimateUI:removeMessage(ID)
```

Removing the message cancels all animations, removes the text from the screen and kills any threads used.

## Demo Options
AnimateUI comes with commands to demonstrate the included effects.

```lua
/AnimateUIDemo type
```


Available types:
* `all` - cycles thorugh all available effects
* `fade` - cycles thorugh all fade effects
* `slide` - cycles thorugh all slide effects
* `bounce` - cycles thorugh all bounce effects
* `elastic` - cycles thorugh all elastic effects
* `zoom` - cycles thorugh all zoom effects
* `typewriter` - cycles thorugh all typewriter effects

## Videos

* Coming soon...

## Contributing
Pull requests welcome.

## Legal

### License

AnimateUI - Animated UI Messages for FiveM

Copyright (C) 2020 Karl Saunders

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.