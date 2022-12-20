module SonicPi::Lang::Sound

  def add_note(n, level=0, duration=1, *args, &blk)
    current_bar = __thread_locals.get(:sonic_pi_bar)
    raise "add_note must be called inside a bar" unless current_bar
    metre = __thread_locals.get(:sonic_pi_metre)

    current_offset = current_bar.current_offset
    shift = metre.quarter_length_to_sonic_pi_beat(metre.get_timing(current_offset))
    note_quarter_lengths = current_bar.add_note(level, duration)

    time_warp shift do
      play(n, *args, &blk)
    end
    # Sleep for the duration of the note
    sleep(metre.quarter_length_to_sonic_pi_beat(note_quarter_lengths))
  end
  doc name:          :add_note,
      introduced:    SonicPi::Version.new(4,0,3),
      summary:       "Adds a note to the current bar",
      doc:           "Plays a given note for a specified duration as part of the current bar on the current synthesizer. `level` specifies the metrical level the note should exist at, as defined by the current metre. Level `0` is the beat level. Levels `1`, `2`, etc. are division levels (e.g. quarter notes, eighth notes, etc.). Levels `-1`, `-2`, etc. are multiple levels (e.g. half notes, whole notes, etc.). `duration` specifies how many of these notes it should last for. This method must be called from within a bar block. The timing of the note will be shifted according to any micro-timing set in the current metre.",
      args:          [[:note, :symbol_or_number], [:level, :number], [:duration, :number]],
      opts:          DEFAULT_PLAY_OPTS,
      accepts_block: true,
      examples:      ["
use_metre '4/4'
bar do
add_note :C4, 1, 1 # Plays the C4 note for one quaver/eighth note
add_note :D4, 0, 3 # Plays the D4 note for three crotchet/quarter notes
end"]
      

  # Shorthand functions assume simple metre for beat level and above
  # Assumes simple or compound for division levels
  def add_whole(n, *args, &blk)
    add_note(n, 0, 4, *args, &blk)
  end

  def add_half_d(n, *args, &blk)
    add_note(n, 0, 3, *args, &blk)
  end

  def add_half(n, *args, &blk)
    add_note(n, 0, 2, *args, &blk)
  end

  def add_quarter_d(n, *args, &blk)
    add_note(n, 1, 3, *args, &blk)
  end

  def add_quarter(n, *args, &blk)
    add_note(n, 0, 1, *args, &blk)
  end

  def add_8th_d(n, *args, &blk)
    add_note(n, 2, 3, *args, &blk)
  end

  def add_8th(n, *args, &blk)
    add_note(n, 1, 1, *args, &blk)
  end

  def add_16th(n, *args, &blk)
    add_note(n, 2, 1, *args, &blk)
  end

  # British names
  def add_semibreve(n, *args, &blk)
    add_note(n, 0, 4, *args, &blk)
  end

  def add_minim_d(n, *args, &blk)
    add_note(n, 0, 3, *args, &blk)
  end

  def add_minim(n, *args, &blk)
    add_note(n, 0, 2, *args, &blk)
  end

  def add_crotchet_d(n, *args, &blk)
    add_note(n, 1, 3, *args, &blk)
  end

  def add_crotchet(n, *args, &blk)
    add_note(n, 0, 1, *args, &blk)
  end

  def add_quaver_d(n, *args, &blk)
    add_note(n, 2, 3, *args, &blk)
  end

  def add_quaver(n, *args, &blk)
    add_note(n, 1, 1, *args, &blk)
  end

  def add_semiquaver(n, *args, &blk)
    add_note(n, 2, 1, *args, &blk)
  end
  

  def add_sample(sample_name, level=0, duration=1, *args, &blk)
    current_bar = __thread_locals.get(:sonic_pi_bar)
    raise "add_sample must be called inside a bar" unless current_bar
    metre = __thread_locals.get(:sonic_pi_metre)

    current_offset = current_bar.current_offset
    shift = metre.quarter_length_to_sonic_pi_beat(metre.get_timing(current_offset))
    note_quarter_lengths = current_bar.add_note(level, duration)

    time_warp shift do
      sample(sample_name, *args, &blk)
    end
    # Sleep for the duration of the note
    sleep(metre.quarter_length_to_sonic_pi_beat(note_quarter_lengths))
  end

  def add_rest(level=0, duration=1)
    current_bar = __thread_locals.get(:sonic_pi_bar)
    raise "add_rest must be called inside a bar" unless current_bar
    metre = __thread_locals.get(:sonic_pi_metre)
    
    # Add the rest as a note to the bar to account for its duration
    rest_quarter_lengths = current_bar.add_note(level, duration)
    sleep(metre.quarter_length_to_sonic_pi_beat(rest_quarter_lengths))
  end
end
