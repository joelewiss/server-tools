# Script to check status of given services and submit it to graphite statistics server
# Joe Lewis (2019)
import time
import subprocess as sp
import telnetlib as tn

GRAPHITE_IP = "192.168.1.13"
GRAPHITE_PORT = 2003
GRAPHITE_PREFIX = "servers.112.services"

SERVICES = [
            "ssh",
            "mscs"
            ]

def submit(service, value):
    epoch = int(time.time())
    name = "{}.{}".format(GRAPHITE_PREFIX, service)
    stat = "{} {} {}\n".format(name, value, epoch)

    graphite.write(stat.encode("ascii"))

if __name__ == "__main__":
    graphite = tn.Telnet(GRAPHITE_IP, GRAPHITE_PORT)

    for service in SERVICES:
        code = sp.run(["systemctl", "is-active", service]).returncode
        if code == 0:
            # print(service + " is running")
            submit(service, 1)
        else:
            # print(service + " is not running")
            submit(service, 0)
