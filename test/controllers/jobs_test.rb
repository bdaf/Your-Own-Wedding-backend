# require 'test_helper'
# class JobsTest < ActionDispatch::IntegrationTest
#     # include Devise::Test::IntegrationHelpers
#     setup do
#       @user = users(:user_one)
#       @header = {
#         'X-User-Email': @user.email,
#         'X-User-Token': @user.authentication_token
#       }
#     end

#     test "can see job data" do      
#       @job = jobs(:job_one)
#       get api_job_path(@job), headers: @header
#       json_response = JSON.parse(response.body)
#         assert_match /http/, json_response["job"]["workspans"][0]['workspan']['reports'][0]['report']['point_of_work_risk_assessment']['overview']
#     end     
# end  
