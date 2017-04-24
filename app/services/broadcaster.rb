class Babble::Broadcaster
  def self.publish_to_topic(topic, user, extras = {})
    MessageBus.publish "/babble/topics/#{topic.id}", serialized_topic(topic, user, extras)
  end

  def self.publish_to_posts(post, user, extras = {})
    MessageBus.publish "/babble/topics/#{post.topic_id}/posts", serialized_post(post, user, extras)
  end

  def self.publish_to_online(topic, users, extras = {})
    MessageBus.publish "/babble/topics/#{topic.id}/online", serialized_online(users)
  end

  def self.publish_to_typing(topic, user, extras = {})
    MessageBus.publish "/babble/topics/#{topic.id}/typing", serialized_presence(user, extras)
  end

  def self.serialized_topic(topic, user, extras = {})
    serialize(topic, user, extras, Babble::TopicSerializer)
  end

  def self.serialized_post(post, user, extras = {})
    serialize(post, user, extras, Babble::PostSerializer)
  end

  def self.serialized_presence(user, extras = {})
    serialize(user, nil, extras, BasicUserSerializer)
  end

  def self.serialized_online(users)
    ActiveModel::ArraySerializer.new(users, each_serializer: BasicUserSerializer).as_json
  end

  def self.serialize(obj, user, extras, serializer)
    serializer.new(obj, scope: Guardian.new(user), root: false).as_json.merge(extras)
  end
end
