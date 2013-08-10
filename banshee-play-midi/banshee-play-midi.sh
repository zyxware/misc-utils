#!/bin/bash

# Copyright 2013 Zyxware Technologies

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

debug=0

# Infinite loop
while :
do
  # Get the path to the current file
  cur_file=`banshee --query-uri | cut -c 13-10000`
  # Get the length of the current track using smfsh since banshee is not 
  # able to stop at the end of the midi files
  cur_track_length=`smfsh $cur_file < in.txt 2>&1 | grep Length | awk '{print $4}' | cut -d. -f1`
  # Get the current position in the current track
  cur_track_pos=`banshee --query-position | awk '{print $2}' | cut -d. -f1`
  if [[ $debug -eq 1 ]]; then
    echo "Playing $cur_file at $cur_track_pos / $cur_track_length seconds"
  fi
  if ! [[ "$cur_track_length" =~ ^[0-9]+$ || "$cur_track_pos" =~ ^[0-9]+$ ]]; then
    banshee --next
  else
    # If banshee has been playing for longer than the duration of the current track then 
    # play the next track
    if [[ $cur_track_pos -gt $cur_track_length ]]; then
      banshee --next
    fi
  fi
  sleep 5
done
