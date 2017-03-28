# encoding: utf-8

require_relative 'intent'
require_relative 'entity'
require_relative '../utils'

module RecastAI
  class Response
    attr_reader :raw
    attr_reader :uuid
    attr_reader :source
    attr_reader :intents
    attr_reader :act
    attr_reader :type
    attr_reader :sentiment
    attr_reader :entities
    attr_reader :language
    attr_reader :version
    attr_reader :timestamp
    attr_reader :status

    def initialize(response)
      @raw = response

      response = JSON.parse(response)
      response = response['results']

      @uuid      = response['uuid']
      @source    = response['source']
      @intents   = response['intents'].map{ |i| Intent.new(i) }
      @act       = response['act']
      @type      = response['type']
      @sentiment = response['sentiment']
      @entities  = response['entities'].flat_map{ |n, e| e.map{ |ee| Entity.new(n, ee) } }
      @language  = response['language']
      @version   = response['version']
      @timestamp = response['timestamp']
      @status    = response['status']
    end

    ##
    # Returns the first intent provided there is one
    #
    # * *Args* :
    # * *Returns* :
    #   - A String or nil
    def intent
      @intents.any? ? @intents.first : nil
    end

    ##
    # Returns the first entity whose name matches the parameter
    #
    # * *Args* :
    #   - +name+ - String, the entity's name
    # * *Returns* :
    #   - An instance of Entity or nil
    def get(name)
      @entities.each do |entity|
        return entity if entity.name.casecmp(name.to_s).zero?
      end

      nil
    end

    ##
    # Returns all entities whose names matches the parameter
    #
    # * *Args* :
    #   - +name+ - String, the entities' names
    # * *Returns* :
    #   - An array of instances of Entity or an empty array
    def all(name)
      @entities.select do |entity|
        entity.name.casecmp(name.to_s).zero?
      end
    end

    ##
    # Return whether or not the act is an assertion
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def assert?
      @act == Utils::ACT_ASSERT
    end

    ##
    # Return whether or not the act is a command
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def command?
      @act == Utils::ACT_COMMAND
    end

    ##
    # Return whether or not the act is a wh-query
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def wh_query?
      @act == Utils::ACT_WH_QUERY
    end

    ##
    # Return whether or not the act is a yn-query
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def yn_query?
      @act == Utils::ACT_YN_QUERY
    end

    ##
    # Return whether or not the type is an abbreviation
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def abbreviation?
      !@type.index(Utils::TYPE_ABBREVIATION).nil?
    end

    ##
    # Return whether or not the type is an entity
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def entity?
      !@type.index(Utils::TYPE_ENTITY).nil?
    end

    ##
    # Return whether or not the type is a description
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def description?
      !@type.index(Utils::TYPE_DESCRIPTION).nil?
    end

    ##
    # Return whether or not the type is a human
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def human?
      !@type.index(Utils::TYPE_HUMAN).nil?
    end

    ##
    # Return whether or not the type is a location
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def location?
      !@type.index(Utils::TYPE_LOCATION).nil?
    end

    ##
    # Return whether or not the type is a number
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def number?
      !@type.index(Utils::TYPE_NUMBER).nil?
    end

    ##
    # Return whether or not the sentiment is very positive
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def vpositive?
      @sentiment == Utils::SENTIMENT_VPOSITIVE
    end

    ##
    # Return whether or not the sentiment is positive
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def positive?
      @sentiment == Utils::SENTIMENT_POSITIVE
    end

    ##
    # Return whether or not the sentiment is neutral
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def neutral?
      @sentiment == Utils::SENTIMENT_NEUTRAL
    end

    ##
    # Return whether or not the sentiment is negative
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def negative?
      @sentiment == Utils::SENTIMENT_NEGATIVE
    end

    ##
    # Return whether or not the sentiment is very negative
    #
    # + *Args* :
    # + *Returns* :
    #   - True or False
    def vnegative?
      @sentiment == Utils::SENTIMENT_VNEGATIVE
    end
  end
end