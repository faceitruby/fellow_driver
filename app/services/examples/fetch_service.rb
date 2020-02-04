module Examples
  class FetchService < ApplicationService
    # @attr_reader params [Hash]
    # - example_id: [Integer] Example ID
    # - example_name: [String] Example name

    # Service should get only one #perform method.
    # Other logic should be under private modifier
    def perform
      examples
    end

    private

    def examples
      Example.find(example_id_param)
    end

    def example_id_param
      params[:example_id].presence
    end
  end
end