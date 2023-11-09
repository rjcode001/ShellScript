#!/bin/bash

# Check if youtube-dl is installed
if ! command -v youtube-dl &> /dev/null; then
    echo "youtube-dl is not installed. Please install it using 'pip install youtube-dl'."
    exit 1
fi

# Input file with video URLs
input_file="video_urls.txt"

# Create an output directory (if it doesn't exist)
output_dir="downloaded_videos"
mkdir -p "$output_dir"

# Read each URL from the input file and download the videos
while IFS= read -r url
do
    # Download the video to the output directory
    youtube-dl -o "$output_dir/%(title)s.%(ext)s" "$url"
done < "$input_file"

echo "Download completed."
