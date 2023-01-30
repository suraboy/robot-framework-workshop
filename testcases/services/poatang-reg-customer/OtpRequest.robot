*** Settings ***
Documentation  API Testing in Robot Framework
Library  SeleniumLibrary
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections

*** Variables ***

*** Test Cases ***
POST Request OTP and return data - success
    [tags]  OTPRequest
    Create Session  mysession  http://localhost:8081  verify=true
    &{body}=  Create Dictionary  title=foo  body=bar  userId=9000
    &{header}=  Create Dictionary  Cache-Control=no-cache
    ${response}=  POST On Session  mysession  /otp/request  data=${body}  headers=${header}
    Status Should Be  200  ${response}  #Check Status as 200

    #Check Response Body
    ${body}=  Convert To String  ${response.content}
    Should Contain  ${body}  content

    #Check the value of the header Content-Type
#    ${getHeaderValue}=  Get From Dictionary  ${response.headers}  Content-Type
#    Should be equal  ${getHeaderValue}  application/json; charset=utf-8

*** Keywords ***