resource "aws_s3_bucket" "bucket" {
  bucket = "mi-bucket-s3-para-mi-lambda"

}
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.cargar_bucket.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}