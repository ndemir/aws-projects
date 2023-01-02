import boto3
import json


def send_email(event, context):
    event = json.loads(event["body"])
    from_email = 'noreply@my-aws-project.com'
    
    to_email = event['email_recipient']
    subject = event['email_subject']
    body = event['email_body']

    # Create an SES client
    client = boto3.client('ses')

    # Send the email
    response = client.send_email(
        Destination={
            'ToAddresses': [
                to_email,
            ]
        },
        Message={
            'Body': {
                'Text': {
                    'Charset': 'UTF-8',
                    'Data': body,
                },
            },
            'Subject': {
                'Charset': 'UTF-8',
                'Data': subject,
            },
        },
        Source=from_email
    )

    return  {"statusCode": 200,"body": json.dumps(response)}
