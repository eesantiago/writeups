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
    <a href="/cgi-bin/status.sh">Status</a>
    <a href="/cgi-bin/edit.sh">Payload</a>
    <a href="/cgi-bin/loot.sh">Loot</a>
    <a href="/cgi-bin/help.sh" class="active">Help</a>
    <a href="javascript:void(0);" class="icon" onclick="xnav()">
      <i class="fa fa-bars"></i>
    </a>
  </div>
  <div class="container">
    <div class="row">
      <div class="eleven column" style="margin-top: 5%">
        <h4>Help</h4>
        <p>
          <ul>
            <li><a href="https://docs.hak5.org">Documentation</a></li>
            <li><a href="https://downloads.hak5.org">Downloads</a></li>
            <li><a href="https://payloads.hak5.org">Payloads</a></li>
            <li><a href="https://forums.hak5.org">Forums</a></li>
          </ul>
        </p>
      </div>
    </div>
  </div>
</body>
</html> 

EOF
