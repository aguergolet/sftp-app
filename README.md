# sftp-app
SFTP Server Docker image 

=== User configuration ===

All user configuration are available into users.json file.

There is some sample private key files into **sample_data** folder. 



=== Snippets ===
Build and run

sudo docker build . -t sftp && sudo docker run --rm --name sftp -p 22000:22000 --privileged -v $(pwd)/home:/home sftp

TODO: Create makefile