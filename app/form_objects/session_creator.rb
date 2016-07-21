class SessionCreator
  attr_reader :twitter_user

  def initialize(twitter_user)
    @twitter_user = twitter_user
  end

  def create
    user = User.find_by(twitter_id: twitter_user.id) || create_user
    user.update(last_sign_in: Time.current, sign_ins: user.sign_ins + 1)
    user
  end

  private

  def create_user
    User.create(twitter_id: twitter_user.id,
                twitter_name: twitter_user.name,
                twitter_screen_name: twitter_user.screen_name).tap do |user|
      user_adder(user).add_to_all_tweet_reviews
      user_adder(user).add_to_all_tweets
    end
  end

  def user_adder(user)
    @user_adder ||= Archiver::UserAdder.new(user)
  end
end
