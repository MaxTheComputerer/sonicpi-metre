module SonicPi::Lang::WesternTheory

  include SonicPi::Metre

  def use_metre(metre, style=nil, &block)
    raise ArgumentError, "use_metre does not work with a block. Perhaps you meant with_metre" if block
    new_metre = SynchronisedMetre.new(metre, style)
    __thread_locals.set(:sonic_pi_metre, new_metre)
  end
  doc name:          :use_metre,
      introduced:    SonicPi::Version.new(4,0,3),
      summary:       "Sets the current metre",
      doc:           "Sets the metre to be used for the current thread. A metre can be defined as a time signature string or a nested list of Rationals. The `style` argument specifies a micro-timing style to apply to music played in this metre.",
      args:          [[:metre, :string_or_list], [:style, :symbol]],
      accepts_block: true,
      examples:      ["use_metre '4/4' # This uses a preset metre represented by a 4/4 time signature",
        "use_metre [[1/8r,1/8r,1/8r], [1/8r,1/8r,1/8r]] # This creates a metre with two beats, each of which can be divided into three eighth notes (the 6/8 time signature)",
        "use_metre '3/4', :viennese_waltz # Uses the micro-timing of the Viennese Waltz style. You should notice the second beat of each bar falls slightly early. Note that the style has to be compatible with the metre.",
      "'2/4' # Supported time signatures
'3/4'
'4/4'
'6/8'
'9/8'
'12/8'",
      "# Supported styles
:viennese_waltz # Second beat is slightly early. Typically uses a 3/4 time signature
:jembe # Micro-timing of jembe music from Mali. Typically uses a 12/8 time signature
:triplet_swing # Jazz swing. Typically uses a 4/4 time signature"]

  def with_metre(metre, style=nil, &block)
    raise ArgumentError, "with_metre must be called with a do/end block. Perhaps you meant use_metre" unless block
    original_metre = __thread_locals.get(:sonic_pi_metre)
    new_metre = SynchronisedMetre.new(metre, style)
    __thread_locals.set(:sonic_pi_metre, new_metre)
    block.call
    __thread_locals.set(:sonic_pi_metre, original_metre)
  end
  doc name:          :with_metre,
      introduced:    SonicPi::Version.new(4,0,3),
      summary:       "Sets the current metre",
      doc:           "Uses the given metre for the `block`. See `use_metre` for details.",
      args:          [[:metre, :string_or_list], [:style, :symbol]],
      accepts_block: true

  def bar(&block)
    raise ArgumentError, "bar must be called with a do/end block" unless block
    metre = __thread_locals.get(:sonic_pi_metre)
    raise "Bar requires a metre to be defined" unless metre
    raise "Bars cannot be nested" if __thread_locals.get(:sonic_pi_bar)
    bar_object = Bar.new
    __thread_locals.set(:sonic_pi_bar, bar_object)

    block.call
    # If the bar has any space remaining, sleep for that time
    sleep(metre.quarter_length_to_sonic_pi_beat(bar_object.remaining_quarter_lengths))
    
    __thread_locals.set(:sonic_pi_bar, nil)
  end
  doc name:          :bar,
      introduced:    SonicPi::Version.new(4,0,3),
      summary:       "Create a new bar",
      doc:           "Creates a new bar in the current metre. All notes played with `add_note` inside the `block` argument will belong to this bar. You cannot add more notes than will fit into the bar's total duration. Bars cannot be nested. If all the notes in a bar don't fill its duration, then the bar automatically sleeps for the remaining time.",
      args:          [],
      accepts_block: true,
      examples:      ["
use_metre '4/4'
bar do
add_note :C4, 1, 1 # Both notes are part of this bar
add_note :D4, 0, 3
# The bar automatically sleeps for the remaining 3 eighth notes
end"]

end
