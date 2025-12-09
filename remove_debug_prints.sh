#!/bin/bash

# Script to remove all debug print statements from the Flutter project
# This will remove lines that contain 'print(' and 'DEBUG' pattern

find lib -name "*.dart" -type f -exec sed -i '/print.*DEBUG/d' {} +

echo "All debug print statements have been removed from the project."