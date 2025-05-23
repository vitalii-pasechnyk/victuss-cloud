module "label_api" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"
  context = module.label.context
  name = "api"
}


resource "aws_api_gateway_rest_api" "this" {
  name = module.label_api.id
  description = "API Gateway"

  endpoint_configuration {
    types = [ "REGIONAL" ]
  }
}

resource "aws_api_gateway_request_validator" "this" {
  name = "validate_request_body"
  rest_api_id = aws_api_gateway_rest_api.this.id
  validate_request_body = true
}

/* resource "aws_api_gateway_resource" "courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "courses"
}

resource "aws_api_gateway_method" "courses_option" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "courses_post" {
  rest_api_id          = aws_api_gateway_rest_api.this.id
  resource_id          = aws_api_gateway_resource.courses.id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.this.id
  # request_models = {
  #   "application/json" = replace("${module.label_api.id}-PostCourse", "-", "")
  # }
}

resource "aws_api_gateway_integration" "courses_integration" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_option.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = <<PARAMS
{ "statusCode": 200 }
PARAMS
  }
}

resource "aws_api_gateway_integration_response" "integration_response_get_all_courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_option.http_method
  status_code = "200"
  #   response_parameters = {
  #     # "method.response.header.access-control-allow-headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
  #     # "method.response.header.access-control-allow-methods" = "'POST,OPTIONS,GET,PUT,PATCH,DELETE'",
  #     # "method.response.header.access-control-allow-origin" = "'*'"
  #   }
  # response_parameters = { "integration.response.header.access-control-allow-origin" = "'*'" }
}

resource "aws_api_gateway_method_response" "courses_option_response_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_option.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "courses_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_option.http_method
  status_code = aws_api_gateway_method_response.courses_option_response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
<?xml version="1.0" encoding="UTF-8"?>
<message>
    $inputRoot.body
</message>
EOF
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "dev"
}

resource "aws_api_gateway_integration" "get_all_courses" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.courses_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda_functions.lambda_courses_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_model" "post_course" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = replace("${module.label_api.id}-PostCourse", "-", "")
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "title": {"type": "string"},
    "authorId": {"type": "string"},
    "length": {"type": "string"},
    "category": {"type": "string"}
  },
  "required": ["title", "authorId", "length", "category"]
}
EOF
} */
// ------ //




 resource "aws_api_gateway_resource" "authors" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "authors"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "get_all_authors" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.authors.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "get_all_authors" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.get_all_authors.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda_functions.lambda_authors_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "get_all_authors" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.authors.id
  http_method     = aws_api_gateway_method.get_all_authors.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_integration_response" "get_all_authors" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.get_all_authors.http_method
  status_code = aws_api_gateway_method_response.get_all_authors.status_code

  # # Transforms the backend JSON response to XML
  # response_templates = {
  #   "application/xml" = <<EOF
  # {
  #    "body" : $input.json('$')
  # }
  # EOF
  # }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

module "cors_authors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.this.id
  api_resource_id = aws_api_gateway_resource.authors.id
}  
/* */

resource "aws_api_gateway_resource" "courses" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "courses"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "get_all_courses" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.courses.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "get_all_courses" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.get_all_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda_functions.lambda_courses_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "get_all_courses" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.get_all_courses.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "get_all_courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_all_courses.http_method
  status_code = aws_api_gateway_method_response.get_all_courses.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}


module "cors_courses" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.this.id
  api_resource_id = aws_api_gateway_resource.courses.id
  
}  

// get-course

resource "aws_api_gateway_resource" "course" {
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "get_course" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "get_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.get_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda_functions.lambda_get_course_invoke_arn
  
  request_templates = {
    "application/json" = <<EOF
{
  "id": "$input.params('id')"
}
EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "get_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.get_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "get_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = aws_api_gateway_method_response.get_course.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method" "delete_course" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "delete_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.delete_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda_functions.lambda_delete_course_invoke_arn
  
  request_templates = {
    "application/json" = <<EOF
{
  "id": "$input.params('id')"
}
EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "delete_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.delete_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "delete_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = aws_api_gateway_method_response.delete_course.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}


resource "aws_api_gateway_method" "save_course" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.courses.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  request_validator_id = aws_api_gateway_request_validator.this.id
}

resource "aws_api_gateway_integration" "save_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.save_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda_functions.lambda_save_course_invoke_arn
  request_templates = {
    "application/json" = <<EOF
{
  "title": $input.json('$.title'),
  "authorId": $input.json('$.authorId'),
  "length": $input.json('$.length'),
  "category": $input.json('$.category')
}
EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "save_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.save_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "save_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.save_course.http_method
  status_code = aws_api_gateway_method_response.save_course.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method" "update_course" {
  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  request_validator_id = aws_api_gateway_request_validator.this.id
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "update_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.update_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda_functions.lambda_update_course_invoke_arn
  request_templates = {
    "application/json" = <<EOF
{
  "id": "$input.params('id')",
  "title": $input.json('$.title'),
  "watchHref": $input.json('$.watchHref'),
  "authorId": $input.json('$.authorId'),
  "length": $input.json('$.length'),
  "category": $input.json('$.category')
}
EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "update_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.update_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "update_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.update_course.http_method
  status_code = aws_api_gateway_method_response.update_course.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}