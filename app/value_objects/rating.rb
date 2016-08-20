class Rating
  SCORES = {
    '0-' => 0,
    '0'  => 1,
    '0+' => 2,
    '1-' => 3,
    '1'  => 4,
    '1+' => 5,
    '2-' => 6,
    '2'  => 7,
    '2+' => 8,
    '3-' => 9,
    '3'  => 10,
    '3+' => 11
  }.freeze

  DESCRIPTIONS = {
    0  => 'Painful',
    1  => 'Unlistenable',
    2  => 'Almost unlistenable',
    3  => 'Barely listenable',
    4  => 'Only worth a listen',
    5  => 'Probably listen only once',
    6  => 'Probably listen more than once',
    7  => 'Listen multiple times',
    8  => 'Definitely listen multiple times',
    9  => 'Almost essential',
    10 => 'Essential',
    11 => 'AOTM contender'
  }.freeze

  SCORE_GROUPS = {
    0 => 'Unlistenable',
    1 => 'Listen Once',
    2 => 'Multiple Listens',
    3 => 'Essential'
  }.freeze

  attr_reader :value

  def self.from_score(score)
    self.new(SCORES[score])
  end

  def self.values_from_score(score_group)
    SCORES.dup.keep_if { |score, value| score[0] == score_group }.values
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

  def ==(other_rating)
    value == other_rating.value
  end
end
