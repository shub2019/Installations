#!/bin/bash

# Define the bucket name where your logs are stored
BUCKET_NAME="Your_bucket_name"

# Define the AWS CLI profile name to use
PROFILE="your_profile_name"

# Output directory where you want to store the results
OUTPUT_DIR="./log_analysis_results"

# File to store the output
OUTPUT_FILE="$OUTPUT_DIR/404_errors_$(date +%Y-%m-%d_%H-%M-%S).txt"

# Check if the output directory exists, if not, create it
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Inform the user about the output file
echo "Storing output in: $OUTPUT_FILE"

# Process each log file found in the S3 bucket
aws s3 ls s3://$BUCKET_NAME/ --recursive --profile $PROFILE | awk '{print $4}' | while read file; do
    # Use AWS CLI to stream the file content and grep to filter for "404"
    # For each line found by grep, prepend the file name for context
    if aws s3 cp s3://$BUCKET_NAME/$file - --profile $PROFILE | grep '404'; then
        # If grep finds lines, prepend the file name to each line and append to the output file
        echo "404 Errors found in $file:" | tee -a "$OUTPUT_FILE"
        aws s3 cp s3://$BUCKET_NAME/$file - --profile $PROFILE | grep '404' | sed "s/^/$file: /" >> "$OUTPUT_FILE"
    else
        # If no lines are found, indicate that in the output file
        echo "No 404 Errors found in $file." | tee -a "$OUTPUT_FILE"
    fi
done

# Final message
echo "Analysis complete. Results stored in: $OUTPUT_FILE"
