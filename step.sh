#!/bin/bash

if [ -z "$RESOURCE_ARCHIVE_URL" ]; then
  echo " [!] RESOURCE_ARCHIVE_URL is not provided - required!"
  exit 1
fi;

if [ -z "$EXTRACT_TO_PATH" ]; then
  echo " [!] EXTRACT_TO_PATH is not provided - required!"
  exit 1
fi;

echo "------------------------------------------------"
echo " Inputs:"
echo "  RESOURCE_ARCHIVE_URL: $RESOURCE_ARCHIVE_URL"
echo "  EXTRACT_TO_PATH: $EXTRACT_TO_PATH"
echo "------------------------------------------------"

# --- Preparations
mkdir "downloads"

# --- Download
curl -fo "downloads/resource" "$RESOURCE_ARCHIVE_URL"
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
if [ ! -d "$EXTRACT_TO_PATH" ]; then
  echo " (i) EXTRACT_TO_PATH directory doesn't exist - creating it..."
  mkdir -p "$EXTRACT_TO_PATH"
  prepare_result=$?
  if [ $prepare_result -eq 0 ]; then
    echo " (i) Directory created"
  else
    echo " [!] Could not create directory! (error code: $prepare_result)"
    exit $prepare_result
  fi;
fi;

# --- Copy to the required location
cp -r unarchived/ "$EXTRACT_TO_PATH"
copy_result=$?
if [ $copy_result -eq 0 ]; then
  echo " (i) Copy OK"
else
  echo " [!] Copy failed! (error code: $copy_result)"
  exit $copy_result
fi;

exit 0