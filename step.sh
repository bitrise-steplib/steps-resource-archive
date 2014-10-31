#!/bin/bash

formatted_output_file_path="$BITRISE_STEP_FORMATTED_OUTPUT_FILE_PATH"

function echo_string_to_formatted_output {
  echo "$1" >> $formatted_output_file_path
}

function write_section_to_formatted_output {
  echo '' >> $formatted_output_file_path
  echo "$1" >> $formatted_output_file_path
  echo '' >> $formatted_output_file_path
}

if [ -z "$RESOURCE_ARCHIVE_URL" ]; then
  echo " [!] RESOURCE_ARCHIVE_URL is not provided - required!"
  write_section_to_formatted_output "# Error!"
  write_section_to_formatted_output "Reason: Source URL is missing."
  exit 1
fi;

if [ -z "$EXTRACT_TO_PATH" ]; then
  echo " [!] EXTRACT_TO_PATH is not provided - required!"
  write_section_to_formatted_output "# Error!"
  write_section_to_formatted_output "Reason: Target path is missing."
  exit 1
fi;

# this expansion is required for paths with ~
#  more information: http://stackoverflow.com/questions/3963716/how-to-manually-expand-a-special-variable-ex-tilde-in-bash
eval expanded_target_path="$EXTRACT_TO_PATH"

echo "------------------------------------------------"
echo " Inputs:"
echo "  RESOURCE_ARCHIVE_URL: $RESOURCE_ARCHIVE_URL"
echo "  EXTRACT_TO_PATH: $expanded_target_path"
echo "------------------------------------------------"

# --- Preparations
mkdir "downloads"
write_section_to_formatted_output "# Steps:"

# --- Download
curl -fo "downloads/resource" "$RESOURCE_ARCHIVE_URL"
curl_result=$?
if [ $curl_result -eq 0 ]; then
  echo " (i) Download OK (not an error response)"
  write_section_to_formatted_output "- Download: successful"
else
  echo " [!] Download failed (error code: $curl_result)"
  write_section_to_formatted_output "- Download: failed"
  exit $curl_result
fi;

# --- Unzip
unzip -u downloads/resource -d unarchived/
unzip_result=$?
if [ $unzip_result -eq 0 ]; then
  echo " (i) Unzip OK"
  write_section_to_formatted_output "- Unzip: successful"
else
  echo " [!] Unzip failed (error code: $unzip_result)"
  write_section_to_formatted_output "- Unzip: failed"
  exit $unzip_result
fi;

# --- Prepare the target path
if [ ! -d "$expanded_target_path" ]; then
  echo " (i) expanded_target_path directory doesn't exist - creating it..."
  mkdir -p "$expanded_target_path"
  prepare_result=$?
  if [ $prepare_result -eq 0 ]; then
    echo " (i) Directory created"
    write_section_to_formatted_output "- Create directory: ${expanded_target_path}"
  else
    echo " [!] Could not create directory! (error code: $prepare_result)"
    write_section_to_formatted_output "- Create directory: failed"
    exit $prepare_result
  fi;
fi;

# --- Copy to the required location
cp -r unarchived/ "$expanded_target_path"
copy_result=$?
if [ $copy_result -eq 0 ]; then
  echo " (i) Copy OK"
  write_section_to_formatted_output "- Copy to directory: successful"
else
  echo " [!] Copy failed! (error code: $copy_result)"
  write_section_to_formatted_output "- Copy to directory: failed"
  exit $copy_result
fi;

exit 0