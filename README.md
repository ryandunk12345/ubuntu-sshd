WARNING
-------

The base image has been changed from debian:jessie to ubuntu:latest. I have 
made this changes due to the old packages version in the debian jessie. If 
you still want to use the debian one, use the tag *debian-latest* or *debian-1.2.1*.


Summary
-------

SSH server image with emacs editor. This image allow to download/upload files 
from/to volumes of a data containers. It allow to browse the mounted 
volumes and edit the files inside theses volumes.


Build the image
---------------

To create this image, execute the following command in the docker-sshd folder.

    docker image build -t cburki/sshd .


Configure the image
-------------------

The following environment variables could be used to configure the users.

 - SSH_PASSWORD : The password for root and given user. No password is set when not specified.
 - SSH_AUTHORIZED_KEY : Your public key that will be added to the authorized key file of the root and given user.
 - SSH_USER : An optional user that will be created.
 
You will not be able to log into this container if you do not provide at
least SSH_PASSWORD or SSH_AUTHORIZED_KEY. Be careful to set a strong password
for the users because they have full access to the volumes you specify to mount
when running the container. When he user SSH_USER is created, the SSH_PASSWORD
and SSH_AUTHORIZED_KEY are also set for this user.


Run the image
-------------

When you run the image, you will bind the SSH port 22. You can add the volume
with the shared data you would like to access.

    docker container run \
        --name sshd \
        -v <volume_name>:<countainer_mount> \
        -d \
        -e SSH_PASSWORD=<your_password> \
        -e SSH_AUTHORIZED_KEY="<your_key>" \
        -p 2222:22 \
        cburki/sshd:latest
