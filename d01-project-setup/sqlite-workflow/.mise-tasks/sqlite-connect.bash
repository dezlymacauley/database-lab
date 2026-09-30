#!/usr/bin/env bash

#MISE description="👷 Build the project | alias = build"
#MISE quiet=true

#______________________________________________________________________________

# STEP: 1 => Generate the build instructions 

# The first `if` block ensures that CMake will only generate 
# build instructions if the `build` directory does not exist.

if [ ! -d "build" ]; then

    # This creates a clean cli output because the output messages from
    # the `CMAKE_GBI_CMD` command will only be shown if an error occured
    # when generating the the build instructions.
    if ! build_instruction_error_messages=$($CMAKE_GBI_CMD 2>&1); then
        printf "\n%s\n\n" '❌ Failed to generate build instructions:'
        printf "%s\n" "$build_instruction_error_messages"
        exit 1
    fi

fi

#______________________________________________________________________________

# STEP: 2 => Build the project

# This creates a clean cli output because the output messages from
# the `CMAKE_BUILD_CMD` command will only be shown if an error occured
# when building the project.
if ! build_output_error_messages=$($CMAKE_BUILD_CMD 2>&1); then
    printf "\n%s\n\n" '❌ Failed to build project'
    printf "%s\n" "$build_output_error_messages"
    exit 1
fi

#______________________________________________________________________________

printf "\n%s\n\n" '✅ All programs in the workspace have been built'
#______________________________________________________________________________
