module GroupMe
  module Messages

    # Create a message for a group
    #
    # @return [Hashie::Mash] Hash representing the message
    # @see http://dev.groupme.com/docs/v3#messages_create
    # @param group_id [String, Integer] Id of the group
    # @param text [String] Text of the message
    # @param attachments [Array<Hash>] Array of attachments
    def create_message(group_id, text, attachments=[])
      data = {
        :message => {
          :source_guid => Time.now.to_s,
          :text => text
        }
      }
      data[:message][:attachments] = attachments if attachments.any?
      response = post("/groups/#{group_id}/messages", data)
      response.env[:body].response.message
    end

    # List messages for a group
    #
    # @return [Array<Hashie::Mash>] Array of hashes representing the messages
    # @see http://dev.groupme.com/docs/v3#messages_index
    # @param group_id [String, Integer] Id of the group
    def messages(group_id, data={})
      get("/groups/#{group_id}/messages", data).messages
    end

    # Get number of messages for a group
    #
    # @return [Integer] Number of messages
    # @param group_id [String, Integer] Id of the group
    def messages_count(group_id)
      get("/groups/#{group_id}/messages")['count']
    end
    alias :message_count :messages_count

    # Upload an image to GroupMe's image service
    #
    # @return String of image url 
    # @see https://dev.groupme.com/docs/image_service
    # @param file [String] path of image
    def upload_image(file)
      data = {
        :file => Faraday::UploadIO.new(file, 'image/jpeg'),
        :access_token => @token
      }
      post("/pictures", data).url
    end

  end
end
