def read_sql_file(file_path):
    """
    Reads an SQL file and returns its content as a string.

    Args:
        file_path (str): The path to the SQL file to be read.

    Returns:
        str or None: The content of the SQL file as a string if successful, 
                     or None if an error occurs.

    Note:
        Make sure to handle exceptions properly in the calling code.
        The function assumes that the SQL file is encoded as UTF-8.
    """
    try:
        with open(file_path, 'r') as file:
            sql_string = file.read()
        return sql_string
    except Exception as e:
        print(f"Error reading SQL file: {e}")
        return None