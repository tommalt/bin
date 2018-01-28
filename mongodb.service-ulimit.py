#!/usr/bin/env python

import sys, os

def replace_db_path(line, index, dbpath):
    # index points to the '--dbpath'
    cur = line.find(' ', index)
    if cur == -1:
        raise ValueError
    cur += 1
    end = line.find(' ', cur)
    if end == -1: end = len(line)
    line = line.replace(line[cur:end], dbpath, 1)
    return line

def main(argv):
    if len(argv) < 2 or argv[1] == '-h' or argv[1] == '--help':
        print("Usage: {} /path/to/mongodb.service".format(argv[0]), file=sys.stderr)
        print("Patches the file to have proper ulimit settings", file=sys.stderr)
        exit(1)
    fname = argv[1]
    ok = os.access(fname, os.R_OK | os.W_OK)
    if not ok:
        print("Error: do not have permission to edit {}".format(fname), file=sys.stderr)
        exit(1)

    things = {
        "LimitFSIZE": "infinity",
        "LimitCPU": "infinity",
        "LimitAS": "infinity",
        "LimitNOFILE": "64000",
        "LimitNPROC": "64000",
    }
    with open(fname, 'r+') as f:
        lines = list(filter(None,[l.strip() for l in f.readlines()]))
        try:
            begin = lines.index("[Service]")
        except ValueError:
            print("Error: [Service] section not found in {}".format(fname), file=sys.stderr)
            exit(1)
        begin += 1
        end = len(lines)
        for i in range(begin,end):
            line = lines[i]
            if line[0] == '[' and line[-1] == ']':
                end = i
                break
        for key in things:
            index_mask = [l.startswith(key) for l in lines[begin:end]]
            if any(index_mask):
                try:
                    index = index_mask.index(True)
                except ValueError:
                    print("Logic error: could not find {} in [Service]. Debug me.".format(key), file=sys.stderr)
                val = lines.pop(begin+index)
                end -= 1
        stuff = [k + '=' + v for k, v in things.items()]
        for thing in stuff:
            lines.insert(end, thing)
            end += 1
        # find the 'ExecStart' line and append --dbpath if it is not set
        index_mask = [l.startswith('ExecStart') for l in lines]
        try:
            index = index_mask.index(True)
        except ValueError:
            print("Error: could not find 'ExecStart' declaration in {}[Service]".format(fname), file=sys.stderr)
            exit(1)
        line = lines[index]
        dbpath = line.find("--dbpath")
        if dbpath == -1:
            line = line + " --dbpath /var/lib/mongodb"
        else:
            try:
                line = replace_db_path(line, dbpath, '/var/lib/mongodb')
                lines[index] = line
            except ValueError:
                print("Error parsing the existing --dbpath in {}[Service]".format(fname), file=sys.stderr)
                exit(1)
        lines[index] = line
        buf = '\n'.join(lines) + '\n'
        f.seek(0)
        f.write(buf)
        f.truncate()
        f.close()
main(sys.argv)
