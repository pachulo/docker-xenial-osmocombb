This docker image contains the latest build from osmocombb and its subprojects:

- osmocombb

Tested Docker host environments are:

- Ubuntu

To run, simply use the following command-line:

    $ docker run -t -i --privileged -v /dev/bus/usb:/dev/bus/usb marcelmaatkamp/osmocombb /bin/bash

To use the osmocombb version:

    $ cd osmocom-bb/src/host/layer23/src/mobile/
    $ ./mobile -i 127.0.0.1

VShould you get an error about the driver already being claimed, exit docker and add a blacklist in the host environment:

    $ sudo su -e "echo 'blacklist dvb_usb_rtl28xxu' >> /etc/modprobe.d/blacklist.conf"
    $ sudo update-initramfs -u
    $ sudo reboot

.. and try again.
   
Dockerfile can be found at [https://github.com/marcelmaatkamp/dockerfile-examples/tree/master/osmocombb/osmocombb-base][1]

  [1]: https://github.com/marcelmaatkamp/dockerfile-examples/tree/master/osmocombb/osmocombb-base
# docker-xenial-osmocombb
