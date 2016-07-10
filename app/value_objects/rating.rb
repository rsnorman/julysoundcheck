class Rating
  SCORES = {
    '0'  => 0,
    '1-' => 1,
    '1'  => 2,
    '1+' => 3,
    '2-' => 4,
    '2'  => 5,
    '2+' => 6,
    '3-' => 7,
    '3'  => 8,
    '3+' => 9
  }

  DESCRIPTIONS = {
    0 => 'Unlistenable',
    1 => 'Barely listenable',
    2 => 'Only worth a listen',
    3 => 'Probably listen only once',
    4 => 'Probably listen more than once',
    5 => 'Listen multiple times',
    6 => 'Definitely listen multiple times',
    7 => 'Almost essential',
    8 => 'Essential',
    9 => 'AOTM contender'
  }

  attr_reader :value

  def self.from_score(score)
    self.new(SCORES[score])
  end

  def initialize(value)
    @value = value
  end

  def to_s
    short_description
  end

  def short_description
    SCORES.key(@value)
  end

  def description
    DESCRIPTIONS[@value]
  end
end
