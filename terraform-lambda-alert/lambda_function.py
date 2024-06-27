import boto3
import os
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

ses = boto3.client('ses', region_name=os.getenv('SES_REGION', 'us-east-1'))

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        # Assuming key format is tsunami-output-<ip>.json
        if key.startswith('tsunami-output-') and key.endswith('.json'):
            ip_address = key[len('tsunami-output-'):-len('.json')]

            # Send email
            sender_email = "your-sender-email@example.com"
            recipient_email = "your-recipient-email@example.com"

            subject = f"Tsunami output file created for {ip_address}"
            body_text = f"A new Tsunami output file has been created for IP address: {ip_address}."
            body_html = f"<html><body><p>A new Tsunami output file has been created for IP address: {ip_address}.</p></body></html>"

            msg = MIMEMultipart('alternative')
            msg['Subject'] = subject
            msg['From'] = sender_email
            msg['To'] = recipient_email

            part1 = MIMEText(body_text, 'plain')
            part2 = MIMEText(body_html, 'html')

            msg.attach(part1)
            msg.attach(part2)

            try:
                response = ses.send_raw_email(
                    Source=sender_email,
                    Destinations=[recipient_email],
                    RawMessage={'Data': msg.as_string()}
                )
                print("Email sent successfully!")
            except Exception as e:
                print(f"Failed to send email: {e}")
