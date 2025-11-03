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
    # owner = "jfsso";
    owner = "SamueleFacenda";
    repo = "trmnl-calendar";
    rev = "53789ad0d269fd5159c7369faccd7ed640716753";
    hash = "sha256-mHi5VB5SDkinNdI7mqgpsO5QW6Q5FbY7lnUPSdQaBJA=";
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
