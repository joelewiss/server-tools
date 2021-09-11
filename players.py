# Gets the number of players on each server in SERVERS and submits to graphite
# statistics server.


import time
import telnetlib as tn

graphite = tn.Telnet("localhost", 2003)

SERVERS = [
    {
        "ip": "192.168.1.12",
        "port": 25565,
        "name": "s",
    },
]

def submit(players, name):
    epoch = int(time.time())
    stat = "servers.112.minecraft.{}.players {} {}\n".format(name, players, epoch) 

    graphite.write(stat.encode("ascii"))

def getPlayers(IP, PORT, NAME):
    try: 
        conn = tn.Telnet(IP, PORT)
        conn.write(bytearray([0xFE]))
    except ConnectionRefusedError:
        return
    
    response = conn.read_all()
    response = response.split(b"\xa7")
    players = int(response[1])

    submit(players, NAME)

if __name__ == "__main__":
    for server in SERVERS:
        getPlayers(server["ip"], server["port"], server["name"]);

    graphite.close();
