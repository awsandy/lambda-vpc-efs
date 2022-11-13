import json
import urllib.request
import os
def lambda_handler(event, context):
    file_name = '/mnt/efs/tmp-file'
    #os.system('ls -l /')
    #os.system('ls -l /mnt/efs')
    from datetime import datetime
    with open(file_name, 'a') as file:
      file.write('Recorded at: %s\n' %datetime.now())
      file.close()
      os.system('cat /mnt/efs/tmp-file')
      os.system('ls -l /mnt/efs')
    return {
      'statusCode': 200,
      'body': json.dumps('Hello from Lambda!')
    }

   
