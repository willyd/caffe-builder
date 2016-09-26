# -- coding: utf-8 --

import os
import re

# match any path of the form DRIVE_LETTER:/path/gh
pattern = r'([a-zA-Z]:/(((?![<>:"/|?*]).)+((?<![ .])/)?)*)'
regex = re.compile(pattern)

class FileNotFoundError(Exception):
    """
    Exception raised when a file is not found
    """

def replace_absolute_paths(filepath, outfilepath=None):
    """
    Replaces absolute paths in a CMake exported targets file
    with paths relative to that targets file in order to make
    them relocatable
    """
    if not os.path.exists(filepath):
        raise FileNotFoundError("File not found: %s" %filepath)
    # get the input file directory and make it absolute
    basepath = os.path.abspath(os.path.dirname(filepath))
    # make this prefix CMake compatible
    prefix = basepath.replace('\\', '/')
    # read the input file
    with open(filepath, 'r') as f:
        content = f.read()
    # any path in the input file
    matches = regex.findall(content)
    # the first group of the match is the full file path
    print(matches)
    for m in matches:
        # make sure that the match and prefix are on the same drive
        if m[0].upper() == basepath[0].upper():
            # find the relative path
            path = os.path.join(basepath, os.path.relpath(m, basepath))
            # make it cmake friendly
            path = path.replace('\\', '/')
            # replace the prefix with a CMake variable
            path = path.replace(prefix, '${CMAKE_CURRENT_LIST_DIR}')
            content = content.replace(m, path)
    if outfilepath is None:
        outfilepath = filepath

    with open(outfilepath, 'w') as f:
        f.write(content)


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='Replace absolute paths in CMake exported targets file.')
    parser.add_argument('inputfile', metavar='i', type=str,
                    help='Input CMake targets file')
    parser.add_argument('outputfile', metavar='o', type=str, nargs='?', default=None,
                    help='Output CMake targets file')
    args = parser.parse_args()
    replace_absolute_paths(args.inputfile, args.outputfile)






