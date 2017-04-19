# DockerNetCore
Dockerfile create with .NET Core and NGINX

Ready for testing your .NET CORE APP develop with VS 2015+


To build the image:

  docker build -t <your-image-name> .

To run the image:

  docker run -d -P -t -p 32769:22 -p 8081:80 --name test1 --env="ROOT_PASS=yourpassword" <your-image-name>
