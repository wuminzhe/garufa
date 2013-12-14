require 'json'

class Message

  ATTRIBUTES = [:channels, :event, :data, :name, :socket_id]

  def initialize(attributes)
    @attributes = ATTRIBUTES.each_with_object({}) do |key, hash|
      hash[key] = attributes[key] || attributes[key.to_s]
    end

    @attributes.each do |name, value|
      instance_variable_set("@#{name}", value)
      self.class.send(:attr_reader, name)
    end
  end

  def to_json
    @attributes.delete_if { |k, v| v.nil? }.to_json
  end

  def self.connection_established(socket_id)
    new(event: 'pusher:connection_established', data: { socket_id: socket_id })
  end

  def self.subscription_succeeded(channel)
    new(event: 'pusher_internal:subscription_succeeded', channel: channel)
  end

  def self.pong
    new(event: 'pusher:pong')
  end

  def self.error(code, message)
    new(event: 'pusher:error', data: { code: code, message: message })
  end
end
