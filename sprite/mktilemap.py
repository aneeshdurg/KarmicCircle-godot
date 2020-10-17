import argparse
import subprocess
import sys

def parse_args(args):
    parser = argparse.ArgumentParser(description="split a png into tiles")
    parser.add_argument("filename", help="source file name")
    parser.add_argument("tilewidth", help="tile width", type=int)
    parser.add_argument("tileheight", help="tile height", type=int)

    return parser.parse_args(args)

def main():
    args = parse_args(sys.argv[1:])

    info = subprocess.check_output(['identify', args.filename]).decode()
    info = info.split(' ')
    assert info[1] == 'PNG'

    dimensions = [int(x) for x in info[2].split('x')]
    assert dimensions[0] % args.tilewidth == 0, "tile width doesn't divide image"
    assert dimensions[1] % args.tileheight == 0, "tile height doesn't divide image"

    for i in range(0, dimensions[1] // args.tileheight):
        for j in range(0, dimensions[0] // args.tilewidth):
            w = args.tilewidth
            h = args.tileheight
            left = j * args.tilewidth
            top = i * args.tileheight
            subprocess.check_call([
                'convert',
                args.filename,
                '-crop',
                f'{w}x{h}+{left}+{top}',
                f'{args.filename}_{i}{j}.png'
            ])

if __name__ == "__main__":
    main()
