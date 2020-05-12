# Proxy List

* **Category:** Miscellaneous
* **Points:** 100
* **Challenge:** We need you to perform geolocation analysis on this list of IPs. We have attributed it to a malicious proxy network. Report back with the prevalent country of origin: ips.txt
* **Hint #1:** The flag is the name of the origin country (case-sensitive) found most frequently in the list
* **Hint #2:** Offline geolocation IP analysis can be scripted with a python package or two
* **Hint #3:** These IPs were collected in late 2019, if necessary you may need to use 'historical' geolocation data

<br />

We can use the [geoiplookup](https://www.ostechnix.com/find-geolocation-ip-address-commandline/) tool to find the Country that an IP address or host‐name originates from.  First lets install it:
```
apt-get install geoip-bin
```

<br />

Next I created a bash script to (1) perform a geoiplookup on each IP (line) in ips.txt, (2) send the results to countries.txt, and (3) count the number of instances each country appears from largest to smallest:
```
#!/bin/bash

for ip in $(cat ips.txt); do
   echo "$(geoiplookup $ip)" >> countries.txt
done

cat countries.txt | sort | uniq -c | sort -rn | head -n1
```

<br />

Execute the script to find the counrty that appears most frequentley:
```
./countries.sh

9572 GeoIP Country Edition: BR, Brazil
```

## Flag: ACI{Brazil}
