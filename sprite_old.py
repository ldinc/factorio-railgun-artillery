try:
    from PIL import Image
except:
    print("not found : PIL (python image library) module, please install PIL or PILLOW (a fork)")
    exit()
import os

source_folder = input("give a folder containing files to be stitched :")

# check if source exists
if os.path.exists(source_folder):
    print("moving to source folder")
    os.chdir(source_folder)
else:
    print("not found '{}'".format(source_folder))
    exit()

# verify that the folder has the user's desired contents
filelist = os.listdir(os.getcwd())
print("contents of DIR:")
print(filelist)

# check the user wants to continue, given the program-understood state of the folder
if not (input("continue?").lower() in ["yes", "y", "continue"]):
    print("exiting")
    exit()


# assume all the files in the folder are the same dimensions
# could be replaced later to check for the largest folder
with Image.open(filelist[0]) as img:
    width, height = img.size


# flag to exit loop
execute = False

output = 1  # number of output files
rows = 0    # number of rows in each file
columns = 0 # number of columns in each file
# the final dimensions of every output file
final_width = 0
final_height = 0

# so we dont ask the user if they want to continue when they havent made any choices yet
first = True
while not execute:
    # status update
    print("files found {}".format(len(filelist)))
    print("files have dimensions of      width      height  (px)")
    print("                              {}       {}".format(width, height))
    print("output files: - {}".format(output))
    print("rows: - - - - - {}".format(rows))
    print("columns:- - - - {}".format(columns))
    print("resulting requirements {} input files".format(output * rows * columns))
    print("files will have resulting dimensions of     width     height (px)")
    print("                                            {}       {}".format(columns*width, rows*height))
    print("and will produce {} files".format(output))
    print("")

    # check if configuration is correct
    if not first:
        if input("execute plan?").lower() in ["execute", "yes", "continue", "y"]:
            print("Executing!")
            final_height = rows*height
            final_width = columns*width
            break
        else:
            print("continuing")

    # get number of rows
    try:
        rows = int(input("per file rows? : "))
    except:
        print("not understood")
        rows = 0

    # get number of columns
    try:
        columns = int(input("per file columns? : "))
    except:
        print("not understood")
        columns = 0

    # given the number of input files and the number of rows/columns
    # this will display an estimate of the number of output files
    print("with the given settings, the reccomended number of output files is")
    print(" {}  output files".format(len(filelist)/(rows*columns)))
    try:
        output = int(input("output files? (default 1): "))
    except:
        print("not understood")
        output = 1

    # after the first loop we can ask the user if they want to execute the plan
    first = False


current_image = 0
print("length of file list: {}".format(len(filelist)))
for o in range(0, output):
    # RGBA for the alpha channel which is important for sprite sheets
    new_image = Image.new('RGBA', (final_width, final_height))
    for y in range(0, columns):
        for x in range(0, rows):
            # try:
            # print(current_image)
            # currently expects the number of input files to perfectly match the number of output * rows * columns
            # but that could be bypassed if needed by checking "if current_image > len(filelist): continue"
            # but I didnt need that functionality so I didnt add it
            with Image.open(filelist[current_image]) as img:
                new_image.paste(img, (x*width, y*height))
            current_image += 1
            # except Exception as e:
            #     print("current file was set to {} ".format(current_image))
            #     print(e)
            #     exit()
    #     print("row done")
    # print("image done")

    # new_image.show("image {}".format(o))
    newfile = "{}x{}_{}x{}_{}.png".format(rows, columns, final_width, final_height, o)
    new_image.save(newfile)
    print("saving: '{}'".format(newfile))
print("done!")