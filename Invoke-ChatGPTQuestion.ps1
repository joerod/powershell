Function Invoke-ChatGPTQuestion {
  [CmdletBinding()]
  param (
    [string]$Question,
    [int]$MaxTokens = 500,
    [int]$Temperature = 0,
    [string]$Model = "text-davinci-003",
    [string]$APIKey
  )
  # Set up the request body
  $body = @{
    model       = $Model
    prompt      = $Question
    max_tokens  = $MaxTokens
    temperature = $Temperature

  } | ConvertTo-Json

  $splat = @{
    Method      = 'Post'
    Uri         = 'https://api.openai.com/v1/completions'
    Body        = $body
    ContentType = 'application/json'
    Headers     = @{'Authorization' = "Bearer $api_key" }
  }
  # Make the API call
  $response = Invoke-RestMethod @splat

  # Process the response
  $response.choices.text
}
#Invoke-ChatGPTQuestion -Question "who owns the knicks" -APIKey $api_key 
