#!/bin/bash
export DISPLAY=:0.0
cd /Venezia/Tracking && pp & 
sleep 5
cd /Venezia/Vizual && pp &
