def copy_log(source_file, destination_file):
    try:
        with open(source_file, 'r') as source:
            with open(destination_file, 'a') as destination:
                # Read the content of the source file and write it to the destination file
                destination.write(source.read())
    except Exception as e:
        print(f"An error occurred: {e}")