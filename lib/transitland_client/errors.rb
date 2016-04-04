module TransitlandClient

  # Inherit from StandardError to provide error classes specific
  # to different parts of the TransitlandClient. An ApiException
  # will be raised when there is an error during an HTTP API call.
  class ApiException < StandardError
  end

  # Inherit from StandardError to provide error classes specific
  # to different parts of the TransitlandClient. A DatabaseException
  # will be raised when there is an error during reading or writing
  # from the local database, which is used to cache data from API calls.
  class DatabaseException < StandardError
  end

  # Inherit from StandardError to provide error classes specific
  # to different parts of the TransitlandClient. An EntityException
  # will be raised when there is an error during the creation of
  # an object which inherits from Entity.
  class EntityException < StandardError
  end
end
