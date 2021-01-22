# MongoDB status script for TrustYa
# https://trustya.app
# Joe Lewis 2021

from time import sleep, time
from struct import pack
import pymongo as pym
import socket as s
import pickle

GRAPHITE_IP = "192.168.1.13"
GRAPHITE_PORT = 2005
GRAPHITE_PREFIX = "servers.116.trustya"
MONGO_IP = "127.0.0.1"
MONGO_PORT = 27017


"""
Retrieves relevant statistics from MongoDB and returns a dictionary
"""
def get_stats(client):
    db = client.polaropera
    stats = {}

    # Process user statistics
    user_colstats = db.command("collstats", "users")
    user_stats = {
        "count": user_colstats["count"],
        "size": user_colstats["totalSize"]
    }
    stats["users"] = user_stats


    # Process feedback statistics
    feedback_colstats = db.command("collstats", "feedback")
    feedback_stats = {
        "count": feedback_colstats["count"],
        "size": user_colstats["totalSize"]
    }
    stats["feedback"] = feedback_stats

    return stats


"""
Submits stastics to local graphite server using graphite's pickle protocol
"""
def submit_stats(sock, stats):
    # Generate a list of tuples for pickling
    t = []
    for key in stats:
        val = stats[key]
        if type(val) is dict:
            for key2 in val:
                t.append(gen_stat_tuple(key + "." + key2, val[key2]))
        else:
            t.append(gen_stat_tuple(key, val))

    print(t)
    payload = pickle.dumps(t, protocol=2)
    header = pack("!L", len(payload))
    message = header + payload

    n = sock.send(message)
    print(f"Successfully sent {n} btytes to graphite")
    if n != len(message):
        print("All bytes were not sent!")


"""
Generates a tuple in the format
(path, (timestamp, value))
for graphite
"""
def gen_stat_tuple(key, val):
    epoch = int(time())
    return (GRAPHITE_PREFIX + "." + key, (epoch, val))


if __name__ == "__main__":
    print("Connecting to mongodb")
    client = pym.MongoClient(MONGO_IP, MONGO_PORT)
    print("Connected to mongodb")
    print("Starting statistics service")

    sock = s.socket(family=s.AF_INET, type=s.SOCK_STREAM, proto=0)
    sock.connect((GRAPHITE_IP, GRAPHITE_PORT))

    while(True):
        try:
            stats = get_stats(client)
            submit_stats(sock, stats)
            sleep(60)
        except (InterruptedError, KeyboardInterrupt):
            break

    print("Closing mongodb connection")
    client.close()
