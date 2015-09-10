#!/bin/bash

if [ -z "$archive_url" ]; then
  echo " [!] archive_url is not provided - required!"
  exit 1
fi;

if [ -z "$extract_to_path" ]; then
  echo " [!] extract_to_path is not provided - required!"
  exit 1
fi;

echo "------------------------------------------------"
echo " Inputs:"
echo "  archive_url: $archive_url"
echo "  extract_to_path: $extract_to_path"
echo "------------------------------------------------"

# --- Preparations
mkdir "downloads"

# --- Download
curl -fo "downloads/resource" "$archive_url"
curl_result=$?
if [ $curl_result -eq 0 ]; then
  echo " (i) Download OK (not an error response)"
else
  echo " [!] Download failed (error code: $curl_result)"
  exit $curl_result
fi;

# --- Unzip
unzip -u downloads/resource -d unarchived/
unzip_result=$?
if [ $unzip_result -eq 0 ]; then
  echo " (i) Unzip OK"
else
  echo " [!] Unzip failed (error code: $unzip_result)"
  exit $unzip_result
fi;

# --- Prepare the target path
if [ ! -d "$extract_to_path" ]; then
  echo " (i) extract_to_path directory doesn't exist - creating it..."
  mkdir -p "$extract_to_path"
  prepare_result=$?
  if [ $prepare_result -eq 0 ]; then
    echo " (i) Directory created"
  else
    echo " [!] Could not create directory! (error code: $prepare_result)"
    exit $prepare_result
  fi;
fi;

# --- Copy to the required location
cp -r unarchived/ "$extract_to_path"
copy_result=$?
if [ $copy_result -eq 0 ]; then
  echo " (i) Copy OK"
else
  echo " [!] Copy failed! (error code: $copy_result)"
  exit $copy_result
fi;

exit 0
