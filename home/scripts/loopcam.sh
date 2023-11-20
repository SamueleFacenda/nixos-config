#!/usr/bin/env bash

set -e

video_sink_camera="/dev/video40"
video_sink_screen="/dev/video41"
video_sink_phone="/dev/video42"
front='\\\_SB_.PCI0.I2C2.CAMF'
back='\\\_SB_.PCI0.I2C3.CAMR'
# not short but easy readable
port_regex='((6553[0-5])|(655[0-2][0-9])|(65[0-4][0-9]{2})|(6[0-4][0-9]{3})|([1-5][0-9]{4})|([0-9]{1,4}))'
ip_port_regex="^(?:(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])(\.(?!:)|:${port_regex}\$)){4}\$"


stop_cam () {
    if pkill .gst-launch-1.0
    then
        echo "Camera stopped successfully"
    else
        echo "Error stopping the camera, fail" 1>&2
        exit 1
    fi
}

loopback_camera () {
    cam="$(get_camera)"
    
    if [[ "$cam" == "$1" ]]
    then
        echo "Camera already started"
        return 0
    fi
    
    if [[ -n "$cam" ]]
    then
        stop_cam > /dev/null
    fi
    
    flip=""
    if [[ "$2" == "flip" ]]
    then
        flip="! videoflip method=horizontal-flip"
    fi       

    gst-launch-1.0 libcamerasrc camera-name="$1" \
        "$flip" \
        ! videoconvert ! v4l2sink "device=$video_sink_camera" \
        > /dev/null 2>&1 & disown
}

get_camera () {
    pgrep -a "gst-launch-1.0" | \
        awk '{print $4}' | \
        cut -d "=" -f 2
}

case $1 in
cam)
    case $2 in
    back)
        loopback_camera "$back" "flip"
        ;;
    front)
        loopback_camera "$front"
        ;;
    stop)
        stop_cam  
        ;;
    get)
        camera=$(get_camera)
        case $camera in
        "$back")
            echo "back camera running"
            ;;
        "$front")
            echo "front camera running"
            ;;
        *)
            echo "unknown camera running: '$camera'"
            ;;
        esac
        ;;
    *)
        echo "Invalid camera option: '$2'. Choose from ['front' 'back' 'stop' 'get']"
        exit 1
        ;;
    esac
    ;;

screen)
    case $2 in
    all|"")
        wf-recorder --muxer=v4l2 --codec=rawvideo --file=$video_sink_screen -x yuv420p \
            > /dev/null 2>&1 & disown
        ;;
    region)
        wf-recorder -g "$(slurp)" --muxer=v4l2 --codec=rawvideo --file=$video_sink_screen -x yuv420p \
            > /dev/null 2>&1 & disown
        ;;
    stop)
        if pkill wf-recorder
        then
            echo "Screen cast stopped succesfully"
        else
            echo "Error stopping the screen cast, fail" 1>&2
            exit 1
        fi
        ;;
    *)
        echo "Invalid screen option: '$2'. Choose from ['all' 'region' 'stop']. Empty is equal to 'all'"
        exit 1
        ;;
    esac
    ;;

net)
    case $2 in
    start)
        if [[ -z $3 ]]
        then
            echo "Network address (ip:port) not provided, exiting..." 1>&2
            exit 1
        fi
        if echo "$3" | grep --invert-match -qP "$ip_port_regex"
            then
                echo "Network address is not a valid ip:port" 1>&2
                exit 1
            fi
        ffmpeg -i "http://${3}/video" -vf format=yuv420p -f v4l2 $video_sink_phone \
            > /dev/null 2>&1 & disown
        ;;
    stop)
        if pkill ffmpeg
        then
            echo "Network cast stopped succesfully"
        else
            echo "Error stopping the network cast, fail" 1>&2
            exit 1
        fi
        ;;
    *)
        echo "Invalid option: '$2'. Choose from ['stop' 'start ip:port']."
        ;;
    esac

    ;;

--help|-h|help)
    echo "Loopcam, an utility for streaming videos to v4l2loopback sinks."
    echo "Available options: "
    echo "cam [front back get stop]  --> start, switch or stop the cast of a surface camera to the sink"
    echo "screen [all region stop]   --> start or stop the casting of the fullscreen or a region to the other sink"
    echo "net [start <ip:port> stop] --> start or stop the cast of a network stream"
    ;;

*)
    echo "Invalid option: '$1'. Run 'loopcam help' to get all the available options"
    exit 1
    ;;
esac
