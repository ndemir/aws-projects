import boto3
import json
def send_verification_email(event, context):

    # Create an SES client
    client = boto3.client('ses')

    event = json.loads(event["body"])
    to_email = event['email_recipient']

    return_body = None
    try:
        # Verify the email address
        result = client.verify_email_identity(EmailAddress=to_email)
        return_body = json.dumps(result)
    except Exception as e:
        # Output error message if fails
        return_body = str(e)
    
    return  {"statusCode": 200,"body": return_body}


