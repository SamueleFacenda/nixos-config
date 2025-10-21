{ buildPythonApplication
, fetchFromGitHub
, certifi
, charset-normalizer 
, icalendar
, icalevents
, idna
, pyparsing
, python-dotenv
, requests 
, six
, urllib3
, x-wr-timezone
, httplib2
, pytz
, recurring-ical-events
}:
buildPythonApplication {
  pname = "trmnl-calendar";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "jfsso";
    repo = "trmnl-calendar";
    rev = "9a5b0c6da6941f1b4feb8b5fe762cebc3b9bfeb7";
    hash = "sha256-fViNiB2qkAS87w3ut2LYuGfhBFbQWQyHLSHBQZhXy+Q=";
  };
  pyproject = false;
  
  dependencies = [
    certifi
    charset-normalizer 
    icalendar
    icalevents
    idna
    pyparsing
    python-dotenv
    requests 
    six
    urllib3
    x-wr-timezone
    httplib2
    pytz
    recurring-ical-events
  ];
  
  prePatch = ''
    sed -i '1i#!/usr/bin/env python' main.py
  '';
  
  installPhase = ''
    install -Dm755 main.py $out/bin/trmnl-calendar
  '';
}
