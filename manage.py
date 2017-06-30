#!/usr/local/bin/python3.6

# Authenticate/Decrypt packet error: bad packet ID (may be a replay): [ #15477 ] -- see the man page entry for --no-replay and --replay-window for more info or silence this warning with --mute-replay-warnings

import requests
import libtorrent
import time, sys, os, datetime
#import subprocess
import dbus

DEFAULT_PORT = 6881
RETRY_PORTS = 10
OUT_DIR = "/tmp/torrents"
DEFAULT_PIA_NODE = "US East.ovpn"
MINUTES_BETWEEN_CHECKS = 5

class IP:
    def __init__(self, s):
        t = s.strip().split('.')
        assert len(t) == 4
        self.addr = (int(t[0]), int(t[1]), int(t[2]), int(t[3]))
    def __eq__(self, othr):
        return self.addr == othr.addr
    def __str__(self):
        return '.'.join([str(i) for i in self.addr])

class Downloader:
    def __init__(self):
        self.session = libtorrent.session()
        self.session.listen_on(DEFAULT_PORT, DEFAULT_PORT+RETRY_PORTS)
        #self.session.set_max_uploads()
        #self.session.set_download_rate_limit()
        #self.session.set_upload_rate_limit()
        if not os.path.isdir(OUT_DIR):
            assert not os.path.isfile(OUT_DIR) 
            os.mkdir(OUT_DIR)
    def add(self, f):
        assert os.path.isfile(f)
        e = libtorrent.bdecode(open(f, 'rb').read())
        info = libtorrent.torrent_info(e)
        self.session.add_torrent({'ti': info, 'save_path': OUT_DIR})
    def status(self):
        downloads = {}
        for torrent in self.session.get_torrents():
            status = torrent.status()
            info = {}
            info['status'] = str(status.state)
            info['progress'] = round(status.progress, 4) # accurate to .1%
            info['down(kb/s)'] = round(status.download_rate/1024, 2) # .10 
            info['up(kb/s)'] = round(status.upload_rate/1024, 2)     # .10
            info['peers'] = status.num_peers
            downloads[torrent.name()] = info
        return downloads
    def delete_seeders(self):
        for torrent in self.session.get_torrents():
            if torrent.is_seeding:
                self.session.remove_torrent(torrent)

#class VpnConn:
#    def __init__(self):
#        username = os.environ.get("PIA_USERNAME")
#        password = os.environ.get("PIA_PASSWORD")
#        self.proc = subprocess.Popen(["openvpn", DEFAULT_PIA_NODE], \
#                stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
#        del username, password


def check_ip():
    # todo throw instead?
    r = requests.get("https://icanhazip.com")
    assert r.ok
    return IP(r.text)

if __name__ == "__main__":
    d = Downloader()
    my_ip = check_ip()
    print("My ip is ", my_ip)
    input("start your engines")
    masked_ip = check_ip()
    d.add("ubuntu-17.04-desktop-amd64.iso.torrent")
    seconds = 0
    while True:
        if seconds % 300 == 0:
            masked_ip = check_ip()
            if masked_ip == my_ip:
                print("Something fucked up")
                exit(42)
        print("\r", datetime.datetime.now(), d.status())
        time.sleep(30)
        seconds += 30
    print("Done")

