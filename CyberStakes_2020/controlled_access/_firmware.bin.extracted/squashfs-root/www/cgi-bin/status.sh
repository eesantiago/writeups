#!/bin/bash
echo -e "Content-type: text/html\n\n"
cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Hak5 Shark Jack</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/css/font-awesome.min.css">
  <link rel="stylesheet" href="/css/normalize.css">
  <link rel="stylesheet" href="/css/skeleton.css">
  <link rel="icon" type="image/png" href="/images/favicon.png">
  <script>
    function xnav() {
    var x = document.getElementById("myTopnav");
    if (x.className === "topnav") {
      x.className += " responsive";
    } else {
      x.className = "topnav";
    }
  }
  </script>
</head>
<body>
  <div class="topnav" id="myTopnav">
    <a href="/cgi-bin/status.sh" class="active">Status</a>
    <a href="/cgi-bin/edit.sh">Payload</a>
    <a href="/cgi-bin/loot.sh">Loot</a>
    <a href="/cgi-bin/help.sh">Help</a>
    <a href="javascript:void(0);" class="icon" onclick="xnav()">
      <i class="fa fa-bars"></i>
    </a>
  </div>
  <div class="container">
    <div class="row">
      <div class="eleven column" style="margin-top: 5%">
        <h4>Status</h4>
        <p>
          <b>Device:</b> <code>$(uci get system.@system[0].hostname)</code><br/>
          <b>Firmware Version:</b> <code>$(cat /root/VERSION)</code><br/>
          <b>Web UI Version:</b> <code>1.0.1</code><br/>
          <b>IP Address:</b> <code>$(ip addr show eth0 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}')</code><br/>
        </p>
        <p><b>Memory</b><br/><pre><code>$(free)</code></pre></p>
        <p><b>Disk</b><br/><pre><code>$(df -h)</code></pre></p>
        <p><b>Routes</b><br/><pre><code>$(route)</code></pre></p>
      </div>
    </div>
  </div>
</body>
</html> 

EOF
