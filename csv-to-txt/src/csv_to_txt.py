from csv import DictReader
import pandas as pd
import os

# to copy file path on Macs:
# right click a file,
# hold down the option key on the keyboard and click on the option "Copy "__" as path name"

def main():
    option_num = 1
    file = input("Paste the file path for the CSV you want to split: ")
    #print(file)
    cols = pd.read_csv(file, index_col=0, nrows=0).columns.tolist()
    for i in cols:
        output_option = str(option_num) + " = " + cols[option_num - 1]
        print(output_option)
        option_num += 1
    print()
    col = int(input("Which column number would you like? "))

    selected_col = cols[col - 1]
    print(selected_col)
    dir = os.path.dirname(file)
    row_num = 1

    with open(file, 'r', encoding="utf8", errors='ignore') as csvfile:
        reader = DictReader(csvfile)
        for row in reader:
            file_name = "{}.txt".format(row_num)
            full_name = os.path.join(dir, "Split_Files/",file_name)
            print(full_name)
            if row[selected_col]:     # if this field is not empty
                line = row[selected_col] + '\n'
            else:
                print("Column empty on {}. Skipping.".format(row_num))
                continue
            os.makedirs(os.path.dirname(full_name), exist_ok=True)
            with open(full_name, "w") as f:
                f.write(line)

            row_num+= 1

main()
