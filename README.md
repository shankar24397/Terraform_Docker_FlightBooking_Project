This Project focuses on optimizing and scaling (in future) containers.

- Containerizing the Django application where we can build the docker image and we can create the infra in AWS which contains a Elastic Container Registry on AWS and pushing a image.
- I have planned to use Redis for Query caching - when many users try to pull all the available flights - i dont want this operation to be data load heavy on my main sqlite3 db. infact redis will manage this swiftly.
- Using terraform we can create the infrastructure on AWS - main.tf contains all the code for infra creation on aws.
  
Im actually making this process in-general(as Template) for my future projects:
  Detailed Description:
    - Let's say whenever i am working on Django application i want to containerize them, so this template would help me just ingest my Docker app code.
      and rest all configurations will be same as it is.



