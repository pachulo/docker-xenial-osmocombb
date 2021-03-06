# docker-xenial-osmocombb

Inspired by [https://github.com/marcelmaatkamp/dockerfile-examples/tree/master/osmocombb/osmocombb-base][1]

This docker image contains the latest build from osmocombb and its subprojects:

- osmocombb

Tested Docker host environments are:

- Ubuntu 16.04

To run, simply use the following command-line:

    $ docker run --device=/dev/ttyUSB0 --rm -it --name test-osmocombb xenial-osmocombb:1.0

To use the osmocombb version, first upload a firmware to the phone:

    $ cd /osmocom-bb/src/host/osmocon
    $ ./osmocon -p /dev/ttyUSB0 -m c123xor ../../target/firmware/board/compal_e88/layer1.compalram.bin

And then connect to the phone:

    $ docker exec -ti test-osmocombb /bin/bash
    $ cd /osmocom-bb/src/host/layer23/src/mobile
    $ ./mobile -i 127.0.0.1

VShould you get an error about the driver already being claimed, exit docker and add a blacklist in the host environment:

    $ sudo su -e "echo 'blacklist dvb_usb_rtl28xxu' >> /etc/modprobe.d/blacklist.conf"
    $ sudo update-initramfs -u
    $ sudo reboot

.. and try again

  [1]: https://github.com/marcelmaatkamp/dockerfile-examples/tree/master/osmocombb/osmocombb-base
