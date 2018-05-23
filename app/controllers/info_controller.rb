class InfoController < ApplicationController
  def dev
  end
      
  def info
    # obj = s3.bucket('eu-icqa-learning-terminal-docs').object(name)
    # obj.upload_file('photo')
    # https://odin.amazon.com/#view/materialSet/com.amazon.access.aws-euicqa-cli_user-1
    # @test_var = Services::S3::list('eu-icqa-learning-terminal-docs', '')[:contents].to_a
    #@test_var = LEARNING_TERMINAL_BUCKET
    #Services::S3.upload(LEARNING_TERMINAL_BUCKET, 'foto.jpg', 'foto.jpg', false)
    
    # s3 = Aws::S3::Resource.new(region: 'eu-west-1')
    # bucket_name = 'eu-icqa-learning-terminal-docs'
    # file_path = '/assets/images/foto.jpg'
    # name = File.basename file_path
    # obj = s3.bucket(bucket_name).object(name)
    # obj.upload_file(file_path)
    
    
    # s3 = Aws::S3::Resource.new(region: 'eu-west-1')
    # file = '/assets/images/foto.jpg'
    # bucket_name = 'eu-icqa-learning-terminal-docs'
    # # Get just the file name
    # name = File.basename(file)
    # # Create the object to upload
    # obj = s3.bucket(bucket_name).object(name)
    # puts "OBJECT"
    # p obj
    
    # # Upload it      
    # obj.upload_file('http://leizagj.aka.corp.amazon.com:3000/assets/images/foto.jpg')
    
    
    # # Create an array of the object keynames in the bucket, up to the first 100
    # lt_bucket = s3.bucket(bucket_name).objects.collect(&:key)
    # puts "LALALA"
    # p lt_bucket
  end
    
  private
    # def download_from_s3
    #   # unless request.xhr?
    #   #   head status :bad_request
    #   #   return
    #   # end
  
    #   signed_url = Services::S3.get_presigned_url(ARCTIC_BLUE_BUCKET, params[:s3_key])
    #   # render json: { signed_url: signed_url }
    # rescue Services::S3::ArgumentError => e
    #   Rails.logger.info e.message
    #   flash[:error] = 'Unable to download file'
    #   redirect_to incident_path
    # end
    
    
    # def upload_to_s3
    #   uploaded_file = params[:file]
    #   unless uploaded_file.present?
    #     flash[:error] = 'File to be uploaded is not specified.'
    #     redirect_to incident_path
    #     return
    #   end
    #   final_filename = params[:new_file_name].presence || uploaded_file.original_filename
    #   Services::S3.upload(
    #     ARCTIC_BLUE_BUCKET,
    #     "#{params[:id]}/#{params[:path]}/#{final_filename}",
    #     uploaded_file.tempfile.path,
    #     params['encrypt'] ? true : false
    #   )
    #   flash[:notice] = 'File uploaded.'
    #   redirect_to incident_path
    # rescue Aws::S3::MultipartUploadError => e
    #   Rails.logger.fatal e.message
    #   flash[:error] = 'Unable to upload file'
    #   redirect_to incident_path
    # rescue GPG::GPGNotExecutable, GPG::GPGExecutionError, GPG::GPGKeyringInitFail => e
    #   Rails.logger.fatal e.message
    #   flash[:error] = 'Unable to encrypt the file'
    #   redirect_to incident_path
    # end
    
    
    # def verify_attachment_name
    #   incident = Incident.find_by(id: params[:id])
    #   return head :bad_request unless incident
  
    #   final_filename = params[:new_file_name].presence || params[:original_filename]
    #   final_filename += '.gpg' if params[:encrypt] == 'true'
    #   file_key = "#{params[:id]}/#{params[:path]}/#{final_filename}"
    #   if Services::S3.object_exists?(ARCTIC_BLUE_BUCKET, file_key)
    #     render text: true
    #   else
    #     render text: false
    #   end
    # end
end
