Leverage Ookla CLI to Periodically Check Internet Download and Upload Speeds
============

## SYNOPSIS
**internet-speed-loop.ps1** [**-i=**<interval_in_minutes>][**-h=**<hours_of_duration>][**-f=**<zip_file_location_of_speedtest.exe>]

## DESCRIPTION
This script is intended to regularly conduct internet speeds via using Ookla CLI. This is not for commercial use. It will download the zip and extract the .exe needed if it is not present in the working directory. Then it will conduct the tests and wraps up migrating the csv file so it is in MB/s for simpler readability.

## OPTIONS

* **-i, -interval**:
  Specify how frequently you'd like to run the speed tests. Something to consider is this can pull a sizeable download if you are operating at a high bandwidth of speed.

* **-h, -hrs**:
  Determine the number of hours (in terms of duration) you want to conduct the speed tests. This does accept floating point numbers so it can support 0.5 for half an hour.
  
* **-f, -file**:
  This defaults to the location of the Ookla Windws Zip download location (current as of 2025-12-05)
