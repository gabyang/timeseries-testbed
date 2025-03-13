import os
import pandas as pd
from datetime import datetime

# Define the directory containing the CSV files
INPUT_DIR = "./"  # Change this if your files are in another directory
PROCESSED_SUFFIX = "_processed.csv"

def process_csv(file_path):
    """Convert the Unix timestamp column to timestamptz format and save a new processed file."""
    df = pd.read_csv(file_path)
    
    # Convert Unix timestamp to timestamptz format
    df['timestamp'] = pd.to_datetime(df['timestamp'], unit='s', utc=True)
    
    # Construct the new filename
    new_file_path = file_path.replace(".csv", PROCESSED_SUFFIX)
    
    # Save the processed CSV
    df.to_csv(new_file_path, index=False)
    print(f"Processed: {file_path} -> {new_file_path}")

def main():
    """Process all CSV files in the directory."""
    for filename in os.listdir(INPUT_DIR):
        if not filename.endswith(PROCESSED_SUFFIX):
            process_csv(os.path.join(INPUT_DIR, filename))

    print("Processing complete.")

def delete_processed():
    """Delete all processed CSV files."""
    for filename in os.listdir(INPUT_DIR):
        if filename.endswith(PROCESSED_SUFFIX):
            os.remove(os.path.join(INPUT_DIR, filename))
            print(f"Deleted: {filename}")

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Process CSV files by converting Unix timestamps to timestamptz.")
    parser.add_argument("action", choices=["process", "delete"], help="Specify 'process' to process CSV files or 'delete' to remove processed files.")

    args = parser.parse_args()

    if args.action == "process":
        main()
    elif args.action == "delete":
        delete_processed()
