#!/bin/bash
pkill java
export DISPLAY=:0.0
cd /Venezia/Tracking && pp & 
sleep 10
 cd /Venezia/Vizual && pp
