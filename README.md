steps-resource-archive
======================

Downloads and extracts a .ZIP archive to a specified path.

# Info
- The archive have to be a .zip
- the uncompressed content of the archive will be moved to the location specified by EXTRACT_TO_PATH
-- this means if your ZIP contains a root folder then the folder will be created at the EXTRACT_TO_PATH too!
-- example: if the zip contains a root folder "ziproot/" and the EXTRACT_TO_PATH is ""


# Input
- RESOURCE_ARCHIVE_URL
- EXTRACT_TO_PATH


# TODO
- other archive formats (right now only .zip is supported)
- option to specify whether the whole folder should be moved into the EXTRACT_TO_PATH path or only it's content
-- (NOTE: if you create a ZIP archive on OSX it will always include a root folder by default)
- error handling: double check if everything is ok
- authentication information, as input (for non public resources)
- option to set whether it should create the folder path of EXTRACT_TO_PATH or not (right now it always creates it if it's not an existing directory)