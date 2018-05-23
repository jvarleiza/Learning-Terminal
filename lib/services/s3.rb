# require 'aws-sdk-for-ruby'
# require 'aws-sdk-s3'
# require 'aws/odin_credentials'
# require 'aws-sdk-core'

module Services
  # The S3 module provides methods for uploading files to S3.
  module S3
    # Setting the VERSION here to avoid uninitialized constant error as described on
    # https://github.com/thoughtbot/paperclip/issues/2484
    Aws::VERSION = 1
    CLIENT = Aws::S3::Client.new(credentials: Aws.config[:credentials])
    SIGNER = Aws::S3::Presigner.new(client: CLIENT)

    module_function

    def get_presigned_url(bucket_name, key_name, expiration = 60)
      SIGNER.presigned_url(:get_object, bucket: bucket_name, key: key_name, expires_in: expiration)
    end

    def list(bucket_name, prefix)
      CLIENT.list_objects(bucket: bucket_name, prefix: prefix, marker: prefix)
    end

    def object_exists?(bucket_name, key_name)
      CLIENT.head_object(bucket: bucket_name, key: key_name)
      true
    rescue Aws::S3::Errors::NotFound
      false
    end

    def upload(bucket_name, filepath, tempfile)
      Aws::S3::Resource.new(client: CLIENT).bucket(bucket_name).object(filepath).upload_file(tempfile)
      File.delete(tempfile) if File.exist?(tempfile)
    end
  end
end
