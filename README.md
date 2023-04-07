# Sonic Pi metre and micro-timing

This is a Ruby gem for [Sonic Pi](https://sonic-pi.net/) which adds functionality for musical metre and probabilistic micro-timing. This is an alternative way of playing music to using Sonic Pi's typical `play` and `sleep` commands. The implementation of metre has been designed to be very generalisable to allow almost any metrical hierarchy to be represented.

The Ruby gem can be found on [RubyGems](https://rubygems.org/gems/sonicpi-metre).



## Installation

If you installed Sonic Pi from the official installer, you can install this gem by running the following command (as an administrator):
```shell
<SONIC-PI-INSTALL-DIR>/app/server/native/ruby/bin/gem install sonicpi-metre
```
Or if you've built Sonic Pi from source using your system's installation of Ruby:
```shell
gem install sonicpi-metre
```


## Usage

After installation, you can use the library in a Sonic Pi project:
```ruby
require 'sonicpi/metre'
```

A simple example of how to play music in this metrical framework is shown below. See the [documentation](#documentation) below for more details.
```ruby
use_metre '4/4'
bar do
  add_note :C4, 1, 1 # Plays the C4 note for one quaver/eighth note
  add_note :D4, 0, 3 # Plays the D4 note for three crotchets/quarter notes
  add_note :E4, 2, 1
  add_note :C4, 2, 1
end
```

The second part of this project was to add style-specific probabilistic micro-timing (like those found in swing rhythms or Viennese waltz music). We define a probability distribution for each metric event and use `time_warp` to adjust the timing of notes played on those events.

To use this, the desired style is passed as an optional second argument to `use_metre` or `with_metre`. E.g.:
```ruby
use_metre '3/4', :viennese_waltz
```


## Documentation

### `use_metre <metre> [style]`

Sets the metre to be used for the current thread.

A metre can be defined as a time signature string or a nested list of Rationals. The `style` argument specifies a micro-timing style to apply to music played in this metre.

Examples:
```ruby
use_metre '4/4' # This uses a preset metre represented by a 4/4 time signature
```
```ruby
use_metre [[1/8r,1/8r,1/8r], [1/8r,1/8r,1/8r]] # This creates a metre with two beats, each of which can be divided into three eighth notes (the 6/8 time signature)
```
```ruby
use_metre '3/4', :viennese_waltz # Uses the micro-timing of the Viennese Waltz style. You should notice the second beat of each bar falls slightly early. Note that the style has to be compatible with the metre.
```
Supported time signatures:
```ruby
'2/4'
'3/4'
'4/4'
'6/8'
'9/8'
'12/8'
```
Supported style presets:
```ruby
:viennese_waltz # Second beat is slightly early. Typically uses a 3/4 time signature
:jembe # Micro-timing of jembe music from Mali. Typically uses a 12/8 time signature
:triplet_swing # Jazz swing. Typically uses a 4/4 time signature
```


### `with_metre <metre> [style] <block>`

Uses the given metre for the `block`. See `use_metre` for details.


### `bar <block>`

Creates a new bar in the current metre.

All notes played with `add_note` inside the `block` argument will belong to this bar. You cannot add more notes than will fit into the bar's total duration. Bars cannot be nested. If all the notes in a bar don't fill its duration, then the bar automatically sleeps for the remaining time.

Example:
```ruby
use_metre '4/4'
bar do
  add_note :C4, 1, 1 # Both notes are part of this bar
  add_note :D4, 0, 3
  # The bar automatically sleeps for the remaining 3 eighth notes
end
```


### `add_note <note> [level=0] [duration=1]`

Plays a given note for a specified duration as part of the current bar on the current synthesizer.

`level` specifies the metrical level the note should exist at, as defined by the current metre. Level `0` is the beat level. Levels `1`, `2`, etc. are division levels (e.g. quarter notes, eighth notes, etc.). Levels `-1`, `-2`, etc. are multiple levels (e.g. half notes, whole notes, etc.). `duration` specifies how many of these notes it should last for. This method must be called from within a bar block.

The timing of the note will be shifted according to any micro-timing set in the current metre. Additional arguments will be passed to the internal call to `play`.

Example:
```ruby
use_metre '4/4'
bar do
  add_note :C4, 1, 1 # Plays the C4 note for one quaver/eighth note
  add_note :D4, 0, 3 # Plays the D4 note for three crotchet/quarter notes
end
```

There are also shorthand functions which wrap calls to `add_note`. They assume simple metre for the beat level and above (<= 0), and assume simple or compound metre for division levels (> 0). These are listed below:
```ruby
add_whole
add_half_d # Dotted half note
add_half
add_quarter_d
add_quarter
add_8th_d
add_8th
add_16th

# British names
add_semibreve
add_minim_d
add_minim
add_crotchet_d
add_crotchet
add_quaver_d
add_quaver
add_semiquaver
```


### `add_sample <sample_name> [level=0] [duration=1]`

Same as `add_note` but will play a sample using Sonic Pi's `sample` command.


### `add_rest [level=0] [duration=1]`

Adds a rest (a period of silence) of the specified length.

