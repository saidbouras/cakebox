# Cakebox

A simple container running cakebox with s6-overlay supervisor.

See [s6-overlay] wiki and [cakebox] github repository for more explanations.


## Set up

To start the cakebox, launch a ```docker run ```  command with the rights properties.
Note that there is only ```php5-fpm``` running inside, you should have a nginx instance
correctly installed previously.

You can see this [nginx] container that match perfectly or any other nginx container including
```/etc/nginx``` and cakebox data root volume, you just have to add ```--volumes-from nginx ```,
therefore cakebox will have access to nginx configuration.


## Usage


- If you have already nginx installed, share the nginx config directory with cakebox.

```sh
docker run --net host --name cakebox -dt \
    -e CAKEBOX_ROOT=/downloads \
    -v path_to_your_files_directory:/downloads \
    -v /var/www/cakebox:/var/www/cakebox \
    -v /etc/nginx:/etc/nginx \
    -p 80:80 \
    rinscy/cakebox:1.0
```


- If you have this [nginx] container started or any other nginx docker container, named here "nginx" :

```sh
docker run --net host --name cakebox -dt \
    -e CAKEBOX_ROOT=/downloads \
    -v path_to_your_files_directory:/downloads \
    -v /var/www/cakebox:/var/www/cakebox \
    --volumes-from nginx \
    -p 80:80 \
    rinscy/cakebox:1.0
```
``` --volumes-from nginx ``` means that cakebox container should use volumes that nginx container
are using.
See the [data volume container] documentation for more details.

Environement variables should be written in uppercase letters like the previous declaration
of ``` CAKEBOX_ROOT ```.
You can manage [cakebox options] with docker environment variables.


### Secure with htaccess
Just put a  ```.htaccess ``` file in the ```CAKEBOX_ROOT ``` directory before starting the application, this  ```.htaccess ``` will be used to secure the cakebox with nginx automatically.

[s6-overlay]: <https://github.com/just-containers/s6-overlay/wiki>
[cakebox]: <https://github.com/cakebox/cakebox>
[nginx]: <https://github.com/rinscy/nginx>
[data volume container]: <https://docs.docker.com/engine/userguide/containers/dockervolumes/#creating-and-mounting-a-data-volume-container>
[cakebox options]: <https://github.com/Cakebox/cakebox/blob/master/config/default.php.dist>