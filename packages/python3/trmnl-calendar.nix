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
    rev = "325318911cdd9e4ac3fc1c1a184c1dde5330a005";
    hash = "sha256-6Nq4XuvuJBN8jVt3Dwbvgub3ERfYjBNpQ9oEMXsuaYs=";
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
