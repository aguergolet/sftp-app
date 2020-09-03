# SFTP Server

Every time I need to configure an SFTP Server, I find many details related to different Linux distribution and details.

This project allows the sysadmins to run an SFTP Server into a container using some basic features like:
* Choose the SFTP Port;
* Use a priv/pub key to login;
* Configure users into a JSON file;
* Limit max connections for each user;

## File Structure

* **users.json**: Sample configuration file with two test users (the private keys are available into ``sample_data`` folder. It could be mapped to your users.json file.

* **./home**: Sample home folder. This folder must be mapped outside the container (to a local folder or docker volume);

* **./sample_data**: Sample public and private keys 

## Building the Container

<code>
sudo docker build . -t sftp
</code>

## Running the Container 

<code>
sudo docker run --rm --name sftp -p 22000:22000 --privileged -v $(pwd)/home:/home -v $(pwd)/users.json:/app/users.json sftp
</code>

## Snippets

<code>
ssh-keygen 
</code>

When the command above ask about filename, I suggest to create the file in current folder and set the username. This command will output two files: [username] and [username.pub]

Into ``users.json`` insert into pubkey user attribute the [username.pub] file content.

To connect to your SFTP Server:
sftp -i [username] -P 22000 [username]@localhost


