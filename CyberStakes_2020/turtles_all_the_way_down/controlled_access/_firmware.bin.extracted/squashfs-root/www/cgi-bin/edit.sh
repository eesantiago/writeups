#!/bin/bash
echo -e "Content-type: text/html\n\n"

# (internal) routine to store POST data
function cgi_get_POST_vars()
{
    # only handle POST requests here
    [ "$REQUEST_METHOD" != "POST" ] && return

    # save POST variables (only first time this is called)
    [ ! -z "$QUERY_STRING_POST" ] && return

    # skip empty content
    [ -z "$CONTENT_LENGTH" ] && return

    # check content type
    # FIXME: not sure if we could handle uploads with this..
    [ "${CONTENT_TYPE}" != "application/x-www-form-urlencoded" ] && \
        echo "bash.cgi warning: you should probably use MIME type "\
             "application/x-www-form-urlencoded!" 1>&2

    # convert multipart to urlencoded
    local handlemultipart=0 # enable to handle multipart/form-data (dangerous?)
    if [ "$handlemultipart" = "1" -a "${CONTENT_TYPE:0:19}" = "multipart/form-data" ]; then
        boundary=${CONTENT_TYPE:30}
        read -N $CONTENT_LENGTH RECEIVED_POST
        # FIXME: don't use awk, handle binary data (Content-Type: application/octet-stream)
        QUERY_STRING_POST=$(echo "$RECEIVED_POST" | awk -v b=$boundary 'BEGIN { RS=b"\r\n"; FS="\r\n"; ORS="&" }
           $1 ~ /^Content-Disposition/ {gsub(/Content-Disposition: form-data; name=/, "", $1); gsub("\"", "", $1); print $1"="$3 }')

    # take input string as is
    else
        read -N $CONTENT_LENGTH QUERY_STRING_POST
    fi

    return
}

# (internal) routine to decode urlencoded strings
function cgi_decodevar()
{
    [ $# -ne 1 ] && return
    local v t h
    # replace all + with whitespace and append %%
    t="${1//+/ }%%"
    while [ ${#t} -gt 0 -a "${t}" != "%" ]; do
        v="${v}${t%%\%*}" # digest up to the first %
        t="${t#*%}"       # remove digested part
        # decode if there is anything to decode and if not at end of string
        if [ ${#t} -gt 0 -a "${t}" != "%" ]; then
            h=${t:0:2} # save first two chars
            t="${t:2}" # remove these
            v="${v}"`echo -e \\\\x${h}` # convert hex to special char
        fi
    done
    # return decoded string
    echo "${v}"
    return
}

# routine to get variables from http requests
# usage: cgi_getvars method varname1 [.. varnameN]
# method is either GET or POST or BOTH
# the magic varible name ALL gets everything
function cgi_getvars()
{
    [ $# -lt 2 ] && return
    local q p k v s
    # get query
    case $1 in
        GET)
            [ ! -z "${QUERY_STRING}" ] && q="${QUERY_STRING}&"
            ;;
        POST)
            cgi_get_POST_vars
            [ ! -z "${QUERY_STRING_POST}" ] && q="${QUERY_STRING_POST}&"
            ;;
        BOTH)
            [ ! -z "${QUERY_STRING}" ] && q="${QUERY_STRING}&"
            cgi_get_POST_vars
            [ ! -z "${QUERY_STRING_POST}" ] && q="${q}${QUERY_STRING_POST}&"
            ;;
    esac
    shift
    s=" $* "
    # parse the query data
    while [ ! -z "$q" ]; do
        p="${q%%&*}"  # get first part of query string
        k="${p%%=*}"  # get the key (variable name) from it
        v="${p#*=}"   # get the value from it
        q="${q#$p&*}" # strip first part from query string
        # decode and assign variable if requested
        [ "$1" = "ALL" -o "${s/ $k /}" != "$s" ] && \
            export "$k"="`cgi_decodevar \"$v\"`"
    done
    return
}

# register all GET and POST variables
cgi_getvars BOTH ALL

if [ $REQUEST_METHOD == 'POST' ]; then
   if [ -n "$filecontent" ]; then
      echo $filecontent > /root/payload/payload.sh
      sed -i 's/\r/\n/g' /root/payload/payload.sh
   fi
fi



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
    <a href="/cgi-bin/edit.sh" class="active">Payload</a>
    <a href="/cgi-bin/loot.sh">Loot</a>
    <a href="/cgi-bin/help.sh">Help</a>
    <a href="javascript:void(0);" class="icon" onclick="xnav()">
      <i class="fa fa-bars"></i>
    </a>
  </div>
  <div class="container">
    <div class="row">
      <div class="eleven column" style="margin-top: 5%">
        <h4>payload.sh</h4>
        <form action="?" method="POST" enctype="application/x-www-form-urlencoded">
        <textarea name="filecontent" style="width:100%" rows="25">$(cat /root/payload/payload.sh)</textarea></br>
        <input type="submit" class="button-primary">
        </form>
      </div>
    </div>
  </div>
</body>
</html> 

EOF
